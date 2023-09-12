### Computer Setup


1. sign in to Preferences iCloud
2. login and download apps from app store



###### Divvy
 7 columns


#### Setting the screenshots directory
```
defaults write com.apple.screencapture location ~/Pictures/Screenshots; killall SystemUIServer
```


### Install Vim Settings

First you need to run `src` to get the uptodate vimrc

Then you install Vundle
```
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
```
Then you install the plugins either with `:PluginInstall` or this snazzy command `vim +PluginInstall +qall`

### Text Editors
