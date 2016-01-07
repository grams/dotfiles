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
    echo "Please run as root."
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

desktop=false
ovh=false
while [[ $# > 0 ]]
do
    key="$1"

    echo $key
    case $key in
        -d|--desktop)
        desktop=true
        shift
        ;;
        -o|--ovh)
        ovh=true
        shift
        ;;
        *)
        shift 
        ;;
    esac
done

codename=`lsb_release -s -c` # e.g. "trusty"

##############################
# Basic Ubuntu
#

# apt updates
apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
echo "deb https://apt.dockerproject.org/repo ubuntu-$codename main" > /etc/apt/sources.list.d/docker.list

apt-get update -q && apt-get upgrade -y
apt-get autoremove -y

# The usual suspects, I always end up installing
apt-get install -y gcc ansible dos2unix gdebi-core git maven openjdk-7-jdk openjdk-8-jdk

# Pythonic stuff (this script is getting too silly)
apt-get install -y python-dev python-pip python-openssl
pip install -U certifi #removes warnings for following pip installs
pip install -U awscli boto3 git-up pep8 thefuck virtualenv

# docker stuff
apt-get install -y docker-engine libyaml-dev
pip install -U docker-compose && chmod +x /usr/local/bin/docker-compose

# JavaScript :'-(
curl -sL https://deb.nodesource.com/setup_4.x | bash -
apt-get update -qq && apt-get upgrade -y
apt-get install -y nodejs
npm install -g grunt-cli

##############################
# Ubuntu Desktop
#
if [ "$desktop" = true ] ; then

    # apt updates
    add-apt-repository -y ppa:webupd8team/mate # mate-dock-applet
    apt-get update -qq

    # The usual suspects, I always end up installing
    apt-get install -y gedit gitk synaptic terminator

    # google chrome
    installWebDeb /opt/google/chrome google-chrome https://dl.google.com/linux/direct google-chrome-stable_current_amd64.deb

    # PyCharm
    pycharm=pycharm-community-5.0.3
    if [ ! -e /usr/local/lib/$pycharm ]; then
        wget http://download.jetbrains.com/python/$pycharm.tar.gz
        tar xzf $pycharm.tar.gz --directory /usr/local/lib  && rm -f $pycharm.tar.gz
    fi
    rm -f /usr/local/bin/pycharm && ln -s /usr/local/lib/$pycharm/bin/pycharm.sh /usr/local/bin/pycharm

    # other useful stuff
    apt-get install -y filezilla mate-dock-applet mysql-workbench
    
fi #desktop

##############################
# OVH remote desktop
#
if [ "$ovh" = true ] ; then

    # tigerVNC
    installWebDeb /usr/bin tigervncserver https://bintray.com/artifact/download/tigervnc/stable/ubuntu-14.04LTS/amd64 tigervncserver_1.5.0-3ubuntu1_amd64.deb
    
fi #ovh

