source ~/src/dotfiles/branch.zsh
source ~/src/dotfiles/worktree.zsh
source ~/src/dotfiles/aliases.zsh
source ~/src/dotfiles/functions.zsh


export PATH=/usr/local/bin:$PATH
export PATH=$PATH:~/src/dotfiles/bin
export PATH=$PATH:./node_modules/.bin
export PATH=$PATH:$HOME/.yarn/bin
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

export EDITOR=vim