#!/bin/bash
#
# Invoke on a fresh Amazon Linux 2 instance like this:
# bash <(curl -L https://github.com/grams/dotfiles/raw/master/myamazondesktop.sh)
#

# Unofficial Bash Strict Mode
set -euo pipefail
IFS=$'\n\t'

##############################
# Basic Amazon Linux 2
#

# yum updates
sudo yum -y update
sudo yum -y install yum-cron
sudo systemctl enable yum-cron.service
sudo systemctl start yum-cron.service

# The usual suspects, I always end up installing
sudo yum -y update dos2unix git maven # shellcheck ec2-api-tools pv

# Dev libs
sudo yum -y groupinstall development
sudo yum -y install zlib-devel
sudo yum -y install openssl-devel

# Pythonic stuff (this script is getting too silly)
sudo yum -y install python3 python3-devel python-pip
sudo pip3 install -U awscli boto3 pep8 thefuck virtualenv

# docker stuff
sudo yum -y install docker
sudo pip install -U docker-compose
sudo usermod -aG docker $USER
sudo systemctl enable docker.service
sudo systemctl start docker.service

# Python...
sudo pip install -U git-up

# Go...
sudo yum -y install go

# Packer
packerversion=1.2.4
packerzip=packer_"$packerversion"_linux_amd64.zip
wget https://releases.hashicorp.com/packer/$packerversion/$packerzip
sudo unzip -u -o $packerzip -d /usr/local/bin
rm -f $packerzip

# And all the rest...
