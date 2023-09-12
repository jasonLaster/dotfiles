brew install cask
brew install wget

# set the screenshots directory
defaults write com.apple.screencapture location ~/Screenshots; killall SystemUIServer

# set git preferences
git config --global core.editor $(which vim)

