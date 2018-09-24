

# Setup HomeBrew
# /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew install cask
brew install wget
brew install mercurial
brew install zsh zsh-completions


# change to zsh and get oh my zsh
chsh -s /bin/zsh
curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh


# Get the solarized colors
cd ~/Downloads
wget https://raw.github.com/altercation/solarized/master/iterm2-colors-solarized/Solarized%20Dark.itermcolors
cd -


# set the screenshots directory
defaults write com.apple.screencapture location ~/Pictures/Screenshots; killall SystemUIServer

# set git preferences
git config --global core.editor $(which vim)

# setup rvm (although, not sure if i want it)
# \curl -sSL https://get.rvm.io | bash -s stable --ruby
