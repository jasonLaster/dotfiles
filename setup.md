### Computer Setup


1. sign in to Preferences iCloud
2. login and download apps from app store

#### Setup Terminal (zsh)

install homebrew + cask to get a lot of the stuff


here's some articles on zsh [article](https://www.xplatform.rocks/2015/05/07/setting-up-iterm2-with-oh-my-zsh-and-powerline-on-osx/)
[article 2](http://sourabhbajaj.com/mac-setup/iTerm/zsh.html)


```
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew install cask
brew install wget

cd ~/Downloads
wget https://raw.github.com/altercation/solarized/master/iterm2-colors-solarized/Solarized%20Dark.itermcolors


iTerm -> Preferences -> Profiles -> Colors -> load presets -> Import

brew install zsh zsh-completions
chsh -s /bin/zsh

curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh
```


download meslo font

```
https://github.com/powerline/fonts/blob/master/Meslo/Meslo%20LG%20M%20DZ%20Regular%20for%20Powerline.otf
```


### Install some apps
  + [sublime](https://www.sublimetext.com/)
  + [atom](https://atom.io/)
  + [iterm](https://www.iterm2.com/downloads.html)
  + [goofy](http://www.goofyapp.com/)
  + [recordit](http://recordit.co/)

+ setup divvy quick
  + 7 columns


### things that can be scripted
+ install zsh
+ clone oh-my-zsh
+ set a directory for screenshots
+ install atom and subl commands
+ install rvm

```
https://rvm.io/rvm/install

\curl -sSL https://get.rvm.io | bash -s stable --ruby
```
+ get pry, setup a gemset...



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

+ get sublime subl command setup (should just work because its in dotfiles...
)

```
ln -s /Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl ~/src/dotfiles/bin/subl
```



#### Atom plugins
+ Sublime-Style-Column-Selection
+ language-diff
