# wt — git worktree manager

Manage git worktrees with fzf-powered branch selection and PR integration.

## Requirements

- `fzf` — fuzzy finder (`brew install fzf`)
- `gh` — GitHub CLI (for PR branch listing)

## Commands

```
wt cd [branch]       Navigate to a worktree (no arg: pick from open PRs)
wt create [branch]   Create a worktree (no arg: pick from git branches)
wt rm [branch]       Remove a worktree (no arg: current, or pick)
wt list              List all worktrees
wt prune [days]      Remove old branches/worktrees (default: 7 days)
```

## How it works

### Layout

Worktrees live in a sibling directory named `<repo>-branches/`:

```
~/src/project/              ← main worktree
~/src/project-branches/
  ├── feature-a/
  ├── feature-b/
  └── bugfix/
```

### `wt cd`

With no argument, shows a fuzzy picker with existing worktrees followed by open PRs (via `gh pr list`). Select an existing worktree to navigate to it, or select a PR branch to create a worktree and cd into it.

With a branch name, navigates directly. Works for any branch — not just open PRs. `wt cd main` is special-cased to cd to the repo root and check out main.

### `wt create`

Creates a worktree and cd's into it. If the branch exists, checks it out; otherwise creates a new branch. On creation:

- Runs `scripts/worktree-add.sh` if present in the repo root
- Sets a deterministic VS Code / Cursor title bar color based on branch name
- Runs `pnpm i` if `package.json` exists

### `wt rm`

Removes a worktree. From inside a worktree, removes the current one and cd's back to main. From outside, opens a fuzzy picker.

### `wt prune`

Delegates to `rm-branches` to bulk-remove branches and worktrees older than N days. Supports `--dry-run` and `--force`.
