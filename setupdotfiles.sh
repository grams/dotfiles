#!/bin/bash
#
# Setup a fresh user account like this:
# 1) Install SSH keys into ~/.ssh
# 2) git clone git@github.com:grams/dotfiles.git ~/.dotfiles
# 3) ~/dotfiles/setupdotfiles.sh
# 

cd ~

# oh-my-git
if [ -d "$HOME/.oh-my-git" ]; then
    bash -c 'cd "$HOME/.oh-my-git" && git pull'
else
    git clone https://github.com/arialdomartini/oh-my-git.git $HOME/.oh-my-git
fi

rm -f ~/.bashrc ~/.bash_aliases
ln -s ~/.dotfiles/.bashrc ~/.bashrc
ln -s ~/.dotfiles/.bash_aliases ~/.bash_aliases

