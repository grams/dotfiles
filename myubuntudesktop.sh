#!/bin/bash

id=`id -u`
if [ $id -ne 0 ]
then
    clear
    echo "Please run as root."
    exit 1
fi

installWebDeb() {
    if [ ! -e $1/$2 ]
    then
        pkg=$4
        wget $3/$4
        gdebi --n $4
        rm -f $4
    else
        echo "$2 is already installed"
    fi
}

codename=`lsb_release -s -c`

# docker
apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
echo "deb https://apt.dockerproject.org/repo ubuntu-$codename main" > /etc/apt/sources.list.d/docker.list

# apt updates
apt update
apt upgrade -y
apt-get autoremove -y

# The usual apt suspects
apt install -y docker-engine gdebi git gitk python-pip synaptic

# The usual python supects
pip install -U certifi
pip install -U virtualenv

# google chrome
installWebDeb /usr/bin google-chrome https://dl.google.com/linux/direct google-chrome-stable_current_amd64.deb

# tigerVNC
installWebDeb /usr/bin tigervncserver https://bintray.com/artifact/download/tigervnc/stable/ubuntu-14.04LTS/amd64 tigervncserver_1.5.0-3ubuntu1_amd64.deb

# mysql-workbench
installWebDeb /usr/bin mysql-workbench http://cdn.mysql.com/Downloads/MySQLGUITools mysql-workbench-community-6.3.4-1ubu1404-amd64.deb

