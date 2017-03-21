#!/bin/bash
#
set -euo pipefail
IFS=$'\n\t'

read -e -p "User name? " -i "`git config --global user.name`" name
if [ ! -z "$name" ]; then
  git config --global user.name $name
fi

read -e -p "Email? " -i "`git config --global user.email`" email
if [ ! -z "$email" ]; then
  git config --global user.email $email
fi

git config --global push.default simple
git config --global rerere.enabled true
git config --global rerere.autoupdate true
git config --global status.submoduleSummary true
