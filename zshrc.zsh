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

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"


export LDFLAGS="-L/usr/local/opt/llvm/lib -Wl,-rpath,/usr/local/opt/llvm/lib"
export PATH="/usr/local/opt/llvm/bin:$PATH"
export LDFLAGS="-L/usr/local/opt/llvm/lib"
export CPPFLAGS="-I/usr/local/opt/llvm/include"


export PATH=/usr/local/bin:$PATH
export PATH=$PATH:/Users/jlaster/src/moz/moz-git-tools
export PATH=$PATH:~/src/dotfiles/bin
export PATH=$PATH:./node_modules/.bin
export PATH=$PATH:$HOME/src/moz/arcanist/bin/
export PATH=$PATH:$HOME/.yarn/bin
export PATH=$HOME/.mozbuild/git-cinnabar:$PATH
export NVM_DIR="$HOME/.nvm"
. "/usr/local/opt/nvm/nvm.sh"

export EDITOR=vim

source ~/src/dotfiles/branch.zsh
source ~/src/dotfiles/aliases.zsh
source ~/src/dotfiles/functions.zsh

source $HOME/.cargo/env

# opam configuration
test -r /Users/jlaster/.opam/opam-init/init.zsh && . /Users/jlaster/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/jlaster/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/jlaster/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/jlaster/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/jlaster/google-cloud-sdk/completion.zsh.inc'; fi
