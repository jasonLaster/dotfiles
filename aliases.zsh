
alias g="git"
alias s="git grep -e \"$1\""
alias be="bundle exec"
alias lss="ls -1"


export WORK="~/work"
export OS="~/src/_os"
export MAR="$OS/marionette"
export JS="$OS/_js"
export MOZ="~/src/mozilla"
export GECKO="~/src/mozilla/gecko"

alias work="cd $WORK"
alias os="cd $OS"
alias m="cd $MAR"
alias moz="cd $MOZ"
alias gecko="cd $GECKO"
alias html="cd ~/src/mozilla/debugger.html"
alias core="cd ~/src/mozilla/devtools-core"
alias reps="cd ~/src/mozilla/devtools-reps"

alias launch="cd ~/src/mozilla/devtools-core/packages/devtools-launchpad"

alias rc="vim ~/.zshrc"
alias src="ruby ~/src/dotfiles/setup.rb; source ~/.zshrc"

# useful way to clear vim temporary files
alias rmswp="rm **/.*swp"

# post a gist file to github if the gist tool is in the path
alias gist-diff="gist --type diff"

alias v="vim"
alias vd="git dms | fpp -c vim"
alias vl="git lhs | fpp -c vim"
alias vsh="git show HEAD --numstat | fpp -c vim"

# fix display camera hangup
alias fix-camera="sudo killall VDCAssistant"

# keep two directories uptodate $srcdir $destdir
# a      - archive mode; same as
# v      - verbose
# delete - delete extraneous files from dest dirs
alias rsync-backup="rsync -av --delete"
alias rsync-backup-dryrun="rsync -avn --delete"

alias unfuck-camera="sudo killall VDCAssistant"

# chrome alias for when I'm working w/ blink
alias canary="/Applications/Google\ Chrome\ Canary.app/Contents/MacOS/Google\ Chrome\ Canary"
alias chrome="/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome"
alias chrome-debug="chrome --remote-debugging-port=9222 --no-first-run --user-data-dir=~/temp/chrome-dev-profile http://localhost:9222\#http://localhost:8001/front_end/inspector.html"
alias python-server="python -m SimpleHTTPServer 8000"

# Git aliases
alias ga="git a"
alias gac="git ac"
alias gb="git b"
alias gba="git ba"
alias gbc="git bc"
alias gbd="git bd"
alias gci="git ci --no-verify"
alias gcia="git cia --no-verify"
alias gcim="git cim --no-verify"
alias gciv="git civ"
alias gcl="git cl"
alias gclf="git clf"
alias gco="git co"
alias gcob="git cob"
alias gcom="git com"
alias gcop="git cop"
alias gd="git d"
alias gdc="git dc"
alias gdcs="git dcs"
alias gdm="git dm"
alias gdms="git dms"
alias gds="git ds"
alias gdw="git dw"
alias gf="git f"
alias gfp="git fp"
alias gg="git g"
alias gl="git l"
alias glo="git lo"
alias glh="git lh"
alias glhj="git lhj"
alias glhs="git lhs"
alias glp="git lp"
alias glpj="git lpj"
alias gls="git ls"
alias gmv="git mv"
alias gr="git r"
alias gra="git ra"
alias grc="git rc"
alias gre="git re"
alias greh="git reh"
alias grehh="git rehh"
alias gri="git ri"
alias grih2="git rih2"
alias grih3="git rih3"
alias grih4="git rih4"
alias grih5="git rih5"
alias grih= "git rih"
alias grmc="git rmc"
alias grpull="git rpull"
alias grs="git rs"
alias gs="git s"
alias gsa="git sa"
alias gsh="git sh"
alias gshs="git shs"
alias gsnp="git snp"
alias gst="git st"
alias gstm="git stm"
