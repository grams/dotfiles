#!/bin/bash
#
# Setup a fresh user account like this:
# 1) Install SSH keys into ~/.ssh
# 2) git clone git@github.com:grams/dotfiles.git ~/.dotfiles
# 3) ~/.dotfiles/setupdotfiles.sh
# 

cd ~

gitInstaller() {
    # Installs from git
    # Sample usage:
    # gitInstaller $HOME/.oh-my-git https://github.com/arialdomartini/oh-my-git.git
    if [ -d "$1" ]; then
        bash -c 'cd "'$1'" && git pull'
    else
        git clone $2 $1
    fi
}

# oh-my-git
gitInstaller $HOME/.oh-my-git https://github.com/arialdomartini/oh-my-git.git
# Copy the awesome fonts to ~/.fonts
gitInstaller /tmp/awesome-terminal-fonts "--branch patching-strategy http://github.com/gabrielelana/awesome-terminal-fonts"
mkdir -p ~/.fonts
cp /tmp/awesome-terminal-fonts/patched/*.* ~/.fonts
rm -rf /tmp/awesome-terminal-fonts
fc-cache -fv ~/.fonts

rm -f ~/.bashrc ~/.bash_aliases
ln -s ~/.dotfiles/.bashrc ~/.bashrc
ln -s ~/.dotfiles/.bash_aliases ~/.bash_aliases

