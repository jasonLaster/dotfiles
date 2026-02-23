# Worktree management: wt create|list|rm|cd

declare -a WORKTREE_COLORS=(
  "#6d28d9"  # Purple
  "#dc2626"  # Red
  "#059669"  # Green
  "#2563eb"  # Blue
  "#ea580c"  # Orange
)

function _wt_ensure_repo() {
  if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "Error: not a git repository"
    return 1
  fi
}

function _wt_main_root() {
  dirname "$(git rev-parse --path-format=absolute --git-common-dir)"
}

function _wt_branches_dir() {
  local main_root=$(_wt_main_root)
  echo "$(dirname "$main_root")/$(basename "$main_root")-branches"
}

function _wt_color() {
  local hash=$(echo "$1" | md5 -q | cut -c1-8)
  local index=$(( (0x$hash % ${#WORKTREE_COLORS[@]}) + 1 ))
  echo "${WORKTREE_COLORS[$index]}"
}

function wt() {
  case "$1" in
    create) shift; _wt_create "$@" ;;
    list|ls) shift; _wt_list "$@" ;;
    rm)     shift; _wt_rm "$@" ;;
    cd)     shift; _wt_cd "$@" ;;
    prune)  shift; rm-branches "$@" ;;
    *)
      echo "Usage: wt <command>"
      echo ""
      echo "Commands:"
      echo "  create <branch>  Create a worktree (creates branch if needed)"
      echo "  list             List all worktrees"
      echo "  rm [branch]      Remove a worktree (default: current)"
      echo "  cd [branch]      Navigate to a worktree (default: main root)"
      echo "  prune [days]     Remove old branches/worktrees (default: 7 days)"
      ;;
  esac
}

function _wt_create() {
  _wt_ensure_repo || return 1

  local branch="$1"
  if [[ -z "$branch" ]]; then
    branch=$(git branch -a --format='%(refname:short)' 2>/dev/null | sed 's|^origin/||' | sort -u | fzf --height=~40% --prompt="branch> ") || return 0
  fi

  local main_root=$(_wt_main_root)
  local worktree_dir="$(_wt_branches_dir)/$branch"

  if [[ -d "$worktree_dir" ]]; then
    echo "Worktree already exists, navigating to: $worktree_dir"
    cd "$worktree_dir"
    return 0
  fi

  # Existing branch → check out; otherwise create new branch
  if git show-ref --verify --quiet "refs/heads/$branch"; then
    git worktree add "$worktree_dir" "$branch" || return 1
  else
    git worktree add -b "$branch" "$worktree_dir" || return 1
  fi

  # Project-specific setup hook
  if [[ -f "$main_root/scripts/worktree-add.sh" ]]; then
    "$main_root/scripts/worktree-add.sh" "$worktree_dir"
  fi

  # VS Code title bar color
  local color=$(_wt_color "$branch")
  mkdir -p "$worktree_dir/.vscode"
  cat > "$worktree_dir/.vscode/settings.json" << EOF
{
  "workbench.colorCustomizations": {
    "titleBar.activeBackground": "$color",
    "titleBar.activeForeground": "#ffffff"
  }
}
EOF

  cd "$worktree_dir"

  if [[ -f "package.json" ]]; then
    echo "Installing dependencies..."
    pnpm i
  fi

  echo "Created worktree: $worktree_dir"
}

function _wt_list() {
  _wt_ensure_repo || return 1
  git worktree list
}

function _wt_rm() {
  _wt_ensure_repo || return 1

  local branch="$1"

  # Default to current worktree's branch, or fzf picker
  if [[ -z "$branch" ]]; then
    local branches_dir=$(_wt_branches_dir)
    local current=$(pwd)
    if [[ "$current" == "$branches_dir"/* ]]; then
      branch="${current#$branches_dir/}"
    else
      branch=$(_wt_list_branches | fzf --height=~40% --prompt="remove worktree> ") || return 0
    fi
  fi

  local worktree_dir="$(_wt_branches_dir)/$branch"

  if [[ ! -d "$worktree_dir" ]]; then
    echo "No worktree found for branch: $branch"
    return 1
  fi

  # Move out if we're inside the worktree being removed
  if [[ "$(pwd)" == "$worktree_dir"* ]]; then
    cd "$(_wt_main_root)"
  fi

  git worktree remove "$worktree_dir" --force
  echo "Removed worktree: $worktree_dir"
}

function _wt_cd() {
  _wt_ensure_repo || return 1

  local branch="$1"

  # No arg → fzf picker of open PRs
  if [[ -z "$branch" ]]; then
    local selection
    selection=$(gh pr list --limit 30 --json headRefName,title,number --jq '.[] | "\(.headRefName)\t#\(.number) \(.title)"' 2>/dev/null \
      | fzf --height=~40% --prompt="pr> " --delimiter='\t' --with-nth=1.. --tabstop=30) || return 0
    branch="${selection%%	*}"
  fi

  local worktree_dir="$(_wt_branches_dir)/$branch"

  if [[ -d "$worktree_dir" ]]; then
    cd "$worktree_dir"
    return 0
  fi

  # Fall back to searching all worktrees (handles main, etc.)
  local match=$(git worktree list | grep "\[$branch\]" | awk '{print $1}')
  if [[ -n "$match" ]]; then
    cd "$match"
    return 0
  fi

  # Branch not checked out locally — create worktree
  _wt_create "$branch"
}

# --- Tab completion ---

function _wt_list_branches() {
  local branches=()

  # Fast: list subdirectories from branches dir
  local bdir=$(_wt_branches_dir 2>/dev/null)
  if [[ -n "$bdir" && -d "$bdir" ]]; then
    for d in "$bdir"/*(N/); do
      branches+=("${d:t}")
    done
  fi

  # Supplement: parse main worktree branch from git
  local line branch
  git worktree list --porcelain 2>/dev/null | while IFS= read -r line; do
    if [[ "$line" == branch\ * ]]; then
      branch="${line#branch refs/heads/}"
      branches+=("$branch")
    fi
  done

  # Deduplicate
  printf '%s\n' "${branches[@]}" | sort -u
}

function _wt_completion() {
  if (( CURRENT == 2 )); then
    compadd create list ls rm cd
    return
  fi

  case "${words[2]}" in
    cd|rm)
      compadd ${(f)"$(_wt_list_branches)"}
      ;;
    create)
      compadd ${(f)"$(git branch -a --format='%(refname:short)' 2>/dev/null | sed 's|^origin/||' | sort -u)"}
      ;;
  esac
}

compdef _wt_completion wt
