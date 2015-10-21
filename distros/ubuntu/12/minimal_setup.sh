#!/bin/sh

#sudo -s
#passwd root
# ENTER 'password'
#userdel user

# Fix repo and install openssh-server
apt-get clean
rm -rf /var/lib/apt/lists/*
rm -rf /var/lib/apt/lists/partial/*
apt-get clean
apt-get update
apt-get upgrade

apt-get install openssh-server openssh-client -y
