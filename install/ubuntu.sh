#!/bin/bash

#To run in root 
# Docker :
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
echo "deb https://apt.dockerproject.org/repo ubuntu-xenial main" >> /etc/apt/sources.list.d/docker.list

# Google chrome
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list

#Git ppa
add-apt-repository ppa:git-core/ppa

apt-get update

apt-get install cifs-utils network-manager-openvpn network-manager-openvpn-gnome konsole kdiff3 compizconfig-settings-manager compiz-plugins-extra
vim-gnome openvpn network-manager-openvpn docker-engine google-chrome-beta zsh git gitk php
