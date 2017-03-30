#!/bin/bash
#
# Setup a fresh user account like this:
# 1) Install SSH keys into ~/.ssh
# 2) git clone git@github.com:grams/dotfiles.git ~/.dotfiles
# 3) ~/.dotfiles/setupdotfiles.sh
#
# Update using ~/.dotfiles/myhomedir.sh
#

# Unofficial Bash Strict Mode
set -euo pipefail
IFS=$'\n\t'
cd ~

#### Utility fn: Install or update from git
gitInstaller() {
    # Installs from git
    # Sample usage:
    # gitInstaller $HOME/.oh-my-git https://github.com/arialdomartini/oh-my-git.git
    if [[ -d "$1" ]]; then
        bash -c 'cd "'$1'" && git pull'
    else
        git clone $2 ${3:-} ${4:-} ${5:-} ${6:-} ${7:-} ${8:-} ${9:-} "$1"
    fi
}

# oh-my-git
gitInstaller "$HOME/.oh-my-git" https://github.com/arialdomartini/oh-my-git.git
## Copy the awesome fonts to ~/.fonts
gitInstaller /tmp/awesome-terminal-fonts --branch patching-strategy http://github.com/gabrielelana/awesome-terminal-fonts
mkdir -p ~/.fonts
cp /tmp/awesome-terminal-fonts/patched/*.* ~/.fonts
rm -rf /tmp/awesome-terminal-fonts
fc-cache -fv ~/.fonts

# Git config
mkdir -p ~/bin
ln -fs ~/.dotfiles/scripts/setupgit.sh ~/bin/setupgit.sh

# Bash config
rm -f ~/.bashrc ~/.bash_aliases
ln -s ~/.dotfiles/.bashrc ~/.bashrc
ln -s ~/.dotfiles/.bash_aliases ~/.bash_aliases

# User specific packages
mkdir -p ~/.gocode
##bash formatter
go get -u github.com/mvdan/sh/cmd/shfmt

#### Utility fn: Shortcuts
shortCut() {
    # Installs a sumbolic link in ~/bin to a given binary
    # Sample usage:
    # shortCut ~/pycharm/bin pycharm.sh
    if [[ -d $HOME/bin ]]; then
      if [[ -x $1/$2 ]]; then
          ln -fs "$1/$2" "$HOME/bin/$2"
        else
          echo "$1/$2 does not exist"
      fi
    fi
}
