ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="robbyrussell2"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how many often would you like to wait before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# plugins=(git)

source $ZSH/oh-my-zsh.sh


### LESS ###
# Enable syntax-highlighting in less.
# brew install source-highlight
# First, add these two lines to ~/.bashrc
export LESSOPEN="| src-hilite-lesspipe.sh %s"
export LESS=" -R "
alias less='less -m -N -g -i -J --underline-special --SILENT'
alias more='less'



# Customize to your needs...
#
fpath=(/usr/local/share/zsh-completions $fpath)

# setup rvm
# source /Users/jasonlaster/.rvm/scripts/rvm

source ~/src/dotfiles/branch.zsh
source ~/src/dotfiles/aliases.zsh
source ~/src/dotfiles/functions.zsh


export PATH=$PATH:~/src/dotfiles/bin
export PATH=$PATH:/Users/jlaster/src/_os/git-cinnabar
export PATH=$PATH:~/bin:~/src/mozilla/moz-git-tools
export PATH=$PATH:~/bin:~/src/mozilla/bin
export PATH=~/.rbenv/bin:$PATH
export PATH=$PATH:./node_modules/.bin


eval "$(rbenv init -)"

source ~/src/mozilla/shortcuts.zsh

export PATH="$HOME/.yarn/bin:$PATH"

export NVM_DIR="/Users/jlaster/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
source /Users/jlaster/.cargo/env

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
