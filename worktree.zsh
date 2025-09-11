# Worktree management functions

# Array of color schemes for VS Code title bar
declare -a WORKTREE_COLORS=(
  "#6d28d9"  # Purple
  "#dc2626"  # Red
  "#059669"  # Green
  "#2563eb"  # Blue
  "#ea580c"  # Orange
)

# Get current branch name
function git-branch-name() {
  git rev-parse --abbrev-ref HEAD
}

# Generate a color index based on branch name hash
function get-color-index() {
  local branch_name="$1"
  local hash=$(echo "$branch_name" | md5sum | cut -c1-8)
  local index=$((0x$hash % 5))
  echo $index
}

# Create a worktree for the current branch
function make-worktree() {
  # Check if we're in a git repository
  if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "❌ Error: This command must be run in a git repository"
    return 1
  fi

  # Get repository name from the current directory
  local repo_name=$(basename "$(git rev-parse --show-toplevel)")
  local repo_parent=$(dirname "$(git rev-parse --show-toplevel)")
  local branch_name=$(git-branch-name)
  local worktree_dir="$repo_parent/${repo_name}-branches/$branch_name"
  
  # Check if worktree already exists
  if [[ -d "$worktree_dir" ]]; then
    echo "⚠️  Worktree for branch '$branch_name' already exists at: $worktree_dir"
    echo "Opening existing worktree..."
    cd "$worktree_dir"
    cursor .
    return 0
  fi

  # Create the worktree
  echo "🌿 Creating worktree for branch: $branch_name"
  
  # Try to create the worktree
  if ! git worktree add "$worktree_dir" "$branch_name" 2>/dev/null; then
    echo "⚠️  Branch '$branch_name' is currently checked out in the main repository"
    echo "🔄 Switching to main branch to free up '$branch_name' for worktree..."
    
    # Switch to main branch (or master if main doesn't exist)
    if git show-ref --verify --quiet refs/heads/main; then
      git checkout main
    elif git show-ref --verify --quiet refs/heads/master; then
      git checkout master
    else
      echo "❌ Could not find main or master branch to switch to"
      return 1
    fi
    
    # Now try creating the worktree again
    echo "🌿 Creating worktree for branch: $branch_name"
    if ! git worktree add "$worktree_dir" "$branch_name"; then
      echo "❌ Failed to create worktree"
      return 1
    fi
  fi

  # Call project-specific worktree setup script if it exists
  if [[ -f "./scripts/worktree-add.sh" ]]; then
    echo "🔧 Running project-specific worktree setup..."
    ./scripts/worktree-add.sh "$worktree_dir"
  else
    echo "ℹ️  No project-specific setup script found (./scripts/worktree-add.sh)"
  fi

  # Create .vscode directory and settings.json
  echo "🎨 Setting up VS Code settings..."
  mkdir -p "$worktree_dir/.vscode"
  
  # Get color index based on branch name
  local color_index=$(get-color-index "$branch_name")
  local selected_color="${WORKTREE_COLORS[$color_index]}"
  
  # Create settings.json with the selected color
  cat > "$worktree_dir/.vscode/settings.json" << EOF
{
  "workbench.colorCustomizations": {
    "titleBar.activeBackground": "$selected_color",
    "titleBar.activeForeground": "#ffffff"
  }
}
EOF

  echo "✅ Worktree created successfully!"
  echo "📍 Location: $worktree_dir"
  echo "🎨 Color: $selected_color"
  
  # Navigate to the worktree
  cd "$worktree_dir"
  
  # Install dependencies if package.json exists
  if [[ -f "package.json" ]]; then
    echo "📦 Installing dependencies with pnpm..."
    pnpm i
    if [[ $? -eq 0 ]]; then
      echo "✅ Dependencies installed successfully!"
    else
      echo "⚠️  Dependency installation failed, but worktree is ready"
    fi
  else
    echo "ℹ️  No package.json found, skipping dependency installation"
  fi
  
  # Launch Cursor
  cursor .
}

# Delete a worktree for the current branch
function delete-worktree() {
  # Check if we're in a git repository
  if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "❌ Error: This command must be run in a git repository"
    return 1
  fi

  # Get repository name from the current directory
  local repo_name=$(basename "$(git rev-parse --show-toplevel)")
  local repo_parent=$(dirname "$(git rev-parse --show-toplevel)")
  local branch_name=$(git-branch-name)
  local worktree_dir="$repo_parent/${repo_name}-branches/$branch_name"
  
  # Check if worktree exists
  if [[ ! -d "$worktree_dir" ]]; then
    echo "⚠️  No worktree found for branch: $branch_name"
    return 1
  fi

  # Confirm deletion
  echo "🗑️  Are you sure you want to delete the worktree for branch '$branch_name'?"
  echo "📍 Location: $worktree_dir"
  read -q "REPLY?Press Y to confirm, any other key to cancel: "
  echo

  if [[ $REPLY =~ ^[Yy]$ ]]; then
    # Remove the worktree
    git worktree remove "$worktree_dir" --force
    
    if [[ $? -eq 0 ]]; then
      echo "✅ Worktree deleted successfully!"
    else
      echo "❌ Failed to delete worktree"
      return 1
    fi
  else
    echo "❌ Deletion cancelled"
  fi
}

# List all worktrees
function list-worktrees() {
  echo "🌿 Available worktrees:"
  git worktree list
}

# Aliases
alias mw="make-worktree"
alias dw="delete-worktree"
alias lw="list-worktrees"
