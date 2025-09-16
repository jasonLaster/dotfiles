#!/usr/bin/env bun

import { existsSync, copyFileSync } from "fs";
import { execSync } from "child_process";

const home = process.env.HOME!;
const dotfilesDir = `${home}/src/dotfiles`;

async function question(query: string): Promise<string> {
  process.stdout.write(query);

  return new Promise((resolve) => {
    process.stdin.once("data", (data) => {
      resolve(data.toString().trim());
    });
  });
}

function highlightDiff(diffOutput: string): string {
  // ANSI color codes for syntax highlighting
  const colors = {
    reset: "\x1b[0m",
    red: "\x1b[31m",
    green: "\x1b[32m",
    yellow: "\x1b[33m",
    blue: "\x1b[34m",
    magenta: "\x1b[35m",
    cyan: "\x1b[36m",
    bold: "\x1b[1m",
  };

  return diffOutput
    .split("\n")
    .map((line) => {
      if (line.startsWith("< ")) {
        return `${colors.red}${line}${colors.reset}`;
      } else if (line.startsWith("> ")) {
        return `${colors.green}${line}${colors.reset}`;
      } else if (line.startsWith("---") || line.startsWith("+++")) {
        return `${colors.cyan}${colors.bold}${line}${colors.reset}`;
      } else if (line.startsWith("@@")) {
        return `${colors.magenta}${colors.bold}${line}${colors.reset}`;
      } else if (line.startsWith("-")) {
        return `${colors.red}${line}${colors.reset}`;
      } else if (line.startsWith("+")) {
        return `${colors.green}${line}${colors.reset}`;
      } else if (line.match(/^\d+[acd]\d+/)) {
        return `${colors.blue}${colors.bold}${line}${colors.reset}`;
      }
      return line;
    })
    .join("\n");
}

async function copyFile(newFile: string, oldFile: string): Promise<void> {
  console.log(`Diffing: ${newFile} and ${oldFile}`);

  try {
    const diff = execSync(`diff ${newFile} ${oldFile}`, { encoding: "utf8" });
    console.log(highlightDiff(diff));
  } catch (error: any) {
    if (error.status === 1) {
      // diff returns 1 when files are different, which is expected
      console.log(highlightDiff(error.stdout));
    } else {
      console.error("Error running diff:", error.message);
    }
  }

  const answer = await question("Approve? (y,n) ");
  if (answer.toLowerCase() === "n") {
    return;
  }

  try {
    copyFileSync(newFile, oldFile);
    console.log(`✅ Copied ${newFile} to ${oldFile}`);
  } catch (error) {
    console.error(`❌ Error copying file: ${error}`);
  }
}

async function main() {
  console.log("🔧 Setting up dotfiles...");

  // Copy gitconfig
  await copyFile(`${dotfilesDir}/gitconfig`, `${home}/.gitconfig`);

  // Uncomment these lines as needed:
  // await copyFile(`${dotfilesDir}/zshrc.zsh`, `${home}/.zshrc`);
  // await copyFile(`${dotfilesDir}/vimrc`, `${home}/.vimrc`);

  console.log("✅ Setup complete!");
  process.exit(0);
}

main().catch((error) => {
  console.error("❌ Setup failed:", error);
  process.exit(1);
});
