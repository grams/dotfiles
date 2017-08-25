#!/bin/bash
#
# Invoke on a fresh ubuntu desktop like this:
# bash <(curl -L https://github.com/grams/dotfiles/raw/master/myubuntudesktop.sh)
#

# Unofficial Bash Strict Mode
set -euo pipefail
IFS=$'\n\t'

# Must be root.
id=`id -u`
if [ $id -ne 0 ]; then
    clear
    echo "Please run as root, with sudo -H"
    exit 1
fi

installWebDeb() {
    # Installs a deb package from internet if command is not already present
    # Sample usage:
    # installWebDeb /usr/bin google-chrome https://dl.google.com/linux/direct google-chrome-stable_current_amd64.deb
    if [ ! -e $1/$2 ]; then
        pkg=$4
        wget $3/$4
        gdebi --n $4
        rm -f $4
    else
        echo "$2 is already installed"
    fi
}

codename=`lsb_release -s -c` # e.g. "trusty"

set +e
wmctrl -m > /dev/null
if [ $? -eq 0 ]; then
    desktop=true
else
    desktop=false
fi
set -e

##############################
# Basic Ubuntu
#

# apt updates
apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
echo "deb https://apt.dockerproject.org/repo ubuntu-$codename main" > /etc/apt/sources.list.d/docker.list

# Addl repos for Ubuntu 16
add-apt-repository -y ppa:fkrull/deadsnakes #Python
add-apt-repository -y ppa:longsleep/golang-backports #Go
add-apt-repository -y ppa:openjdk-r/ppa # OpenJDK 7

apt-get update -q && apt-get upgrade -y
apt-get autoremove -y

# The usual suspects, I always end up installing
apt-get install -y gcc dos2unix gdebi-core git unzip maven openjdk-7-jdk openjdk-8-jdk shellcheck ec2-api-tools pv

# Pythonic stuff (this script is getting too silly)
apt-get install -y python-dev python-pip python-openssl python3-dev python3 python3.6 python3.6-dev python3.6-venv
pip install -U pip certifi #removes warnings for following pip installs
pip install -U awscli boto3 pep8 thefuck virtualenv

# docker stuff
apt-get install -y docker-engine libyaml-dev
pip install -U docker-compose && chmod +x /usr/local/bin/docker-compose

# Python...
pip install -U git-up # fixes The 'six==1.9.0' distribution was not found and is required by git-up

# Go...
apt-get install -y golang-go

# JavaScript :'-(
curl -sL https://deb.nodesource.com/setup_4.x | bash -
apt-get update -qq && apt-get upgrade -y
apt-get install -y nodejs
npm install -g grunt-cli

# Packer
packerversion=1.0.3
packerzip=packer_"$packerversion"_linux_amd64.zip
wget https://releases.hashicorp.com/packer/$packerversion/$packerzip
unzip -u -o $packerzip -d /usr/local/bin
rm -f $packerzip

# And all the rest...
apt-get install -y linkchecker php php-mysql php-xdebug ansible

##############################
# Ubuntu Desktop
#
if [ "$desktop" = true ] ; then

    # apt updates
    add-apt-repository -y ppa:webupd8team/mate # mate-dock-applet
    apt-get update -qq

    # The usual suspects, I always end up installing
    apt-get install -y gedit gitk meld synaptic terminator xclip

    # google chrome
    installWebDeb /opt/google/chrome google-chrome https://dl.google.com/linux/direct google-chrome-stable_current_amd64.deb

    # other useful stuff
    apt-get install -y filezilla mate-dock-applet mysql-workbench

fi #desktop
