#!/bin/bash
#
set -euo pipefail
IFS=$'\n\t'

read -e -p "User name? " -i `git config --global user.name` name
git config --global user.name $name

read -e -p "Email? " -i `git config --global user.email` email
git config --global user.email $email

git config --global push.default simple

