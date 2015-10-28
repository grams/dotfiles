#!/bin/bash
#
# Invoke on a fresh ubuntu desktop like this:
# bash <(curl -L https://github.com/grams/dotfiles/raw/master/myubuntudesktop.sh)
#

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

codename=`lsb_release -s -c` # e.g. "trusty"

# apt updates
apt update -qq
apt upgrade -y
apt-get autoremove -y

# The usual suspects, I always end up installing
apt install -y gdebi git gitk synaptic

# Pythonic stuff (this script is getting too silly)
apt install -y python-dev python-pip
pip install -U certifi #removes warnings for following pip installs
pip install -U pep8 thefuck virtualenv
pycharm=pycharm-community-4.5.4
if [ ! -e /usr/local/lib/$pycharm ]; then
    wget https://d1opms6zj7jotq.cloudfront.net/python/$pycharm.tar.gz
    tar xzf $pycharm.tar.gz --directory /usr/local/lib  && rm -f $pycharm.tar.gz
fi


# docker stuff
apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
echo "deb https://apt.dockerproject.org/repo ubuntu-$codename main" > /etc/apt/sources.list.d/docker.list
apt update -qq
apt install -y docker-engine libyaml-dev
pip install -U docker-compose && chmod +x /usr/local/bin/docker-compose

# google chrome
installWebDeb /usr/bin google-chrome https://dl.google.com/linux/direct google-chrome-stable_current_amd64.deb

# tigerVNC
installWebDeb /usr/bin tigervncserver https://bintray.com/artifact/download/tigervnc/stable/ubuntu-14.04LTS/amd64 tigervncserver_1.5.0-3ubuntu1_amd64.deb

# mysql-workbench
installWebDeb /usr/bin mysql-workbench http://cdn.mysql.com/Downloads/MySQLGUITools mysql-workbench-community-6.3.4-1ubu1404-amd64.deb

