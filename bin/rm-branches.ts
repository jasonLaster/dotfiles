#!/usr/bin/env bun

/**
 * Git Branch Cleanup Script
 * Automatically removes local branches and worktrees older than specified days
 *
 * Usage: rm-branches [options] [days]
 *
 * @example
 * rm-branches
 * rm-branches 14 --dry-run
 * rm-branches --force 30
 */

import { parseArgs } from "util";
import { $, type ShellOutput } from "bun";
import { rm } from "fs/promises";

// Configuration
const DEFAULT_DAYS_OLD = 7;
const PROTECTED_BRANCHES = ["main", "master", "develop", "development"];

// Colors for console output
const colors = {
  red: "\x1b[31m",
  green: "\x1b[32m",
  yellow: "\x1b[33m",
  blue: "\x1b[34m",
  dim: "\x1b[2m",
  reset: "\x1b[0m",
};

// Utility functions for colored output
const print = {
  info: (msg: string) =>
    console.log(`${colors.blue}ℹ️  ${msg}${colors.reset}`),
  success: (msg: string) =>
    console.log(`${colors.green}✅ ${msg}${colors.reset}`),
  warning: (msg: string) =>
    console.log(`${colors.yellow}⚠️  ${msg}${colors.reset}`),
  error: (msg: string) =>
    console.log(`${colors.red}❌ ${msg}${colors.reset}`),
  dim: (msg: string) =>
    console.log(`${colors.dim}   ${msg}${colors.reset}`),
};

interface CleanupOptions {
  daysOld: number;
  dryRun: boolean;
  force: boolean;
  help: boolean;
}

interface BranchInfo {
  name: string;
  lastCommitUnix: number;
  lastCommitRelative: string;
  hasWorktree: boolean;
}

interface WorktreeInfo {
  path: string;
  branch: string | null; // null for detached HEAD
  lastCommitUnix: number;
  isDetached: boolean;
}

function showUsage(): void {
  console.log(`
Git Branch Cleanup Script

USAGE:
    rm-branches [OPTIONS] [DAYS_OLD]

OPTIONS:
    -d, --dry-run     Show what would be deleted without actually deleting
    -f, --force       Skip confirmation prompts
    -h, --help        Show this help message

ARGUMENTS:
    DAYS_OLD          Number of days old branches must be to delete (default: ${DEFAULT_DAYS_OLD})

EXAMPLES:
    rm-branches                    # Delete branches older than 7 days
    rm-branches 14                 # Delete branches older than 14 days
    rm-branches --dry-run          # Show what would be deleted
    rm-branches --force 30         # Delete without confirmation
    rm-branches -d 5               # Dry run for 5+ day old branches

PROTECTED BRANCHES:
    These branches will never be deleted: ${PROTECTED_BRANCHES.join(", ")}
`);
}

function parseArguments(): CleanupOptions {
  const { values, positionals } = parseArgs({
    args: Bun.argv.slice(2),
    options: {
      "dry-run": { type: "boolean", short: "d" },
      force: { type: "boolean", short: "f" },
      help: { type: "boolean", short: "h" },
    },
    allowPositionals: true,
  });

  if (values.help) {
    showUsage();
    process.exit(0);
  }

  let daysOld = DEFAULT_DAYS_OLD;
  if (positionals.length > 0) {
    const parsed = parseInt(positionals[0], 10);
    if (isNaN(parsed) || parsed < 0) {
      print.error(
        `Invalid days argument: ${positionals[0]}. Expected a positive number.`
      );
      process.exit(1);
    }
    daysOld = parsed;
  }

  return {
    daysOld,
    dryRun: Boolean(values["dry-run"]),
    force: Boolean(values.force),
    help: Boolean(values.help),
  };
}

async function checkGitRepository(): Promise<void> {
  try {
    await $`git rev-parse --git-dir`.quiet();
  } catch {
    print.error("Not in a git repository!");
    process.exit(1);
  }
}

function isProtectedBranch(branch: string): boolean {
  return PROTECTED_BRANCHES.includes(branch);
}

async function getRepositoryInfo(): Promise<{
  path: string;
  currentBranch: string;
}> {
  const path = await $`git rev-parse --show-toplevel`.text();
  const currentBranch = await $`git branch --show-current`.text();
  return {
    path: path.trim(),
    currentBranch: currentBranch.trim(),
  };
}

/** Get the commit date for a given ref, returning 0 if it can't be determined */
async function getCommitUnix(ref: string): Promise<number> {
  try {
    const result = await $`git log -1 --format=%ct ${ref}`.quiet().text();
    const unix = parseInt(result.trim(), 10);
    return isNaN(unix) ? 0 : unix;
  } catch {
    return 0;
  }
}

async function getOldBranches(
  daysOld: number,
  worktreeBranches: Set<string>
): Promise<BranchInfo[]> {
  const cutoffDate =
    Math.floor(Date.now() / 1000) - daysOld * 24 * 60 * 60;
  const currentBranch = await $`git branch --show-current`
    .text()
    .then((t) => t.trim());

  try {
    const branchData =
      await $`git for-each-ref --format='%(refname:short)|%(committerdate:unix)|%(committerdate:relative)' refs/heads/`.text();

    return branchData
      .trim()
      .split("\n")
      .filter((line) => line.trim())
      .map((line) => {
        const [name, unix, relative] = line.split("|");
        return {
          name,
          lastCommitUnix: parseInt(unix, 10),
          lastCommitRelative: relative,
          hasWorktree: worktreeBranches.has(name),
        };
      })
      .filter(
        (branch) =>
          branch.lastCommitUnix < cutoffDate &&
          !isProtectedBranch(branch.name) &&
          branch.name !== currentBranch
      );
  } catch (error) {
    print.error(`Failed to get branch information: ${error}`);
    return [];
  }
}

async function getOldWorktrees(daysOld: number): Promise<WorktreeInfo[]> {
  const cutoffDate =
    Math.floor(Date.now() / 1000) - daysOld * 24 * 60 * 60;
  const repoRoot = await $`git rev-parse --show-toplevel`
    .text()
    .then((t) => t.trim());

  try {
    const worktreeList = await $`git worktree list --porcelain`.text();
    const worktrees: WorktreeInfo[] = [];

    const entries = worktreeList.trim().split("\n\n");

    for (const entry of entries) {
      const lines = entry.split("\n");
      const worktreeLine = lines.find((line) => line.startsWith("worktree "));
      const branchLine = lines.find((line) => line.startsWith("branch "));
      const isDetached = lines.some((line) => line === "detached");

      if (!worktreeLine) continue;

      const path = worktreeLine.replace("worktree ", "");

      // Skip the main worktree
      if (path === repoRoot) continue;

      let branch: string | null = null;
      if (branchLine) {
        branch = branchLine.replace("branch refs/heads/", "");
        if (isProtectedBranch(branch)) continue;
      }

      // For detached HEAD or branch-based worktrees, check the commit date
      // Use the branch ref if available, otherwise use the worktree HEAD
      const ref = branch ? `refs/heads/${branch}` : `${path}/HEAD`;
      const lastCommitUnix = branch
        ? await getCommitUnix(`refs/heads/${branch}`)
        : await getCommitUnixFromWorktreePath(path);

      if (lastCommitUnix > 0 && lastCommitUnix < cutoffDate) {
        worktrees.push({ path, branch, lastCommitUnix, isDetached });
      }
    }

    return worktrees;
  } catch {
    return [];
  }
}

/** Get commit date for a worktree by reading its HEAD directly */
async function getCommitUnixFromWorktreePath(
  worktreePath: string
): Promise<number> {
  try {
    // git log works from any worktree path
    const result =
      await $`git --work-tree=${worktreePath} log -1 --format=%ct HEAD`.quiet().text();
    const unix = parseInt(result.trim(), 10);
    return isNaN(unix) ? 0 : unix;
  } catch {
    // If we can't determine the date, fall back to directory mtime
    try {
      const { Stat } = await import("fs/promises").then((m) => ({
        Stat: m.stat,
      }));
      const stats = await Stat(worktreePath);
      return Math.floor(stats.mtimeMs / 1000);
    } catch {
      return 0;
    }
  }
}

async function askConfirmation(message: string): Promise<boolean> {
  console.log(message);
  process.stdout.write("Are you sure you want to continue? [y/N] ");

  for await (const line of console) {
    const response = line.toString().trim().toLowerCase();
    return response === "y" || response === "yes";
  }

  return false;
}

/**
 * Remove a worktree directory using rm -rf (much faster than git worktree remove
 * for directories with node_modules), then prune git's worktree metadata.
 */
async function removeWorktreeDir(path: string): Promise<void> {
  // Use rm() from fs/promises - fast and doesn't spawn a subprocess
  await rm(path, { recursive: true, force: true });
}

async function cleanupWorktrees(
  worktrees: WorktreeInfo[],
  options: CleanupOptions
): Promise<void> {
  if (worktrees.length === 0) {
    print.info("No old worktrees found.");
    return;
  }

  if (options.dryRun) {
    print.warning(
      `[DRY RUN] Would remove ${worktrees.length} old worktree(s):`
    );
    for (const worktree of worktrees) {
      const date = new Date(
        worktree.lastCommitUnix * 1000
      ).toLocaleDateString();
      const branchLabel = worktree.branch ?? "detached HEAD";
      console.log(
        `  - ${worktree.path} (branch: ${branchLabel}, last commit: ${date})`
      );
    }
    return;
  }

  print.info(`Found ${worktrees.length} old worktree(s) to remove:`);
  for (const worktree of worktrees) {
    const date = new Date(
      worktree.lastCommitUnix * 1000
    ).toLocaleDateString();
    const branchLabel = worktree.branch ?? "detached HEAD";
    console.log(
      `  - ${worktree.path} (branch: ${branchLabel}, last commit: ${date})`
    );
  }

  if (!options.force) {
    const confirmed = await askConfirmation("\nRemoving worktrees...");
    if (!confirmed) {
      print.info("Worktree removal cancelled.");
      return;
    }
  }

  // Remove all worktree directories in parallel (this is the slow part)
  print.info("Removing worktree directories...");
  const results = await Promise.allSettled(
    worktrees.map(async (worktree) => {
      await removeWorktreeDir(worktree.path);
      return worktree;
    })
  );

  let removedCount = 0;
  let failedCount = 0;

  for (const result of results) {
    if (result.status === "fulfilled") {
      print.success(`Removed: ${result.value.path}`);
      removedCount++;
    } else {
      print.error(`Failed to remove: ${result.reason}`);
      failedCount++;
    }
  }

  // Prune git's worktree metadata once after all directories are removed
  try {
    await $`git worktree prune`.quiet();
    print.dim("Pruned stale worktree metadata");
  } catch {
    print.warning("Failed to prune worktree metadata");
  }

  if (removedCount > 0) {
    print.success(`Successfully removed ${removedCount} worktree(s)`);
  }
  if (failedCount > 0) {
    print.warning(`${failedCount} worktree(s) could not be removed`);
  }
}

async function cleanupBranches(
  branches: BranchInfo[],
  options: CleanupOptions
): Promise<void> {
  if (branches.length === 0) {
    print.info("No old branches found.");
    return;
  }

  if (options.dryRun) {
    print.warning(
      `[DRY RUN] Would delete ${branches.length} old branch(es):`
    );
    for (const branch of branches) {
      const worktreeTag = branch.hasWorktree ? " [has worktree]" : "";
      console.log(
        `  - ${branch.name} (last commit: ${branch.lastCommitRelative})${worktreeTag}`
      );
    }
    return;
  }

  print.info(`Found ${branches.length} old branch(es) to delete:`);
  for (const branch of branches) {
    const worktreeTag = branch.hasWorktree ? " [has worktree]" : "";
    console.log(
      `  - ${branch.name} (last commit: ${branch.lastCommitRelative})${worktreeTag}`
    );
  }

  if (!options.force) {
    const confirmed = await askConfirmation("\nDeleting branches...");
    if (!confirmed) {
      print.info("Branch deletion cancelled.");
      return;
    }
  }

  let deletedCount = 0;
  let failedCount = 0;

  for (const branch of branches) {
    try {
      await $`git branch -D ${branch.name}`.quiet();
      print.success(`Deleted branch: ${branch.name}`);
      deletedCount++;
    } catch {
      print.error(`Failed to delete branch: ${branch.name}`);
      failedCount++;
    }
  }

  if (deletedCount > 0) {
    print.success(`Successfully deleted ${deletedCount} branch(es)`);
  }
  if (failedCount > 0) {
    print.warning(`${failedCount} branch(es) could not be deleted`);
  }
}

async function main(): Promise<void> {
  try {
    const options = parseArguments();
    await checkGitRepository();

    const { path, currentBranch } = await getRepositoryInfo();

    print.info("Git Branch Cleanup Script");
    print.info(`Repository: ${path}`);
    print.info(`Current branch: ${currentBranch}`);
    print.info(`Cleaning branches older than: ${options.daysOld} days`);
    print.info(`Protected branches: ${PROTECTED_BRANCHES.join(", ")}`);

    if (options.dryRun) {
      print.warning("DRY RUN MODE - No changes will be made");
    }

    console.log();

    // Get old worktrees and branches
    print.info("Analyzing repository...");
    const oldWorktrees = await getOldWorktrees(options.daysOld);

    // Track which branches have worktrees so we know to clean worktrees first
    const worktreeBranches = new Set(
      oldWorktrees
        .filter((wt) => wt.branch !== null)
        .map((wt) => wt.branch as string)
    );

    const oldBranches = await getOldBranches(options.daysOld, worktreeBranches);

    // Clean up worktrees first (they prevent branch deletion)
    print.info("Checking for old worktrees...");
    await cleanupWorktrees(oldWorktrees, options);

    console.log();

    // Clean up branches (now safe since worktrees are gone)
    print.info("Checking for old branches...");
    await cleanupBranches(oldBranches, options);

    console.log();
    print.success("Cleanup completed!");

    // Show final stats
    const remainingBranches =
      await $`git branch --format='%(refname:short)'`.text();
    const remainingWorktrees = await $`git worktree list`.text();

    const branchCount = remainingBranches
      .trim()
      .split("\n")
      .filter((b) => b.trim()).length;
    const worktreeCount = remainingWorktrees
      .trim()
      .split("\n")
      .filter((w) => w.trim()).length;

    print.info(`Remaining branches: ${branchCount}`);
    print.info(`Remaining worktrees: ${worktreeCount}`);
  } catch (error) {
    print.error(`Script failed: ${error}`);
    process.exit(1);
  }
}

// Run the script
await main();
