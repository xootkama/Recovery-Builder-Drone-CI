#!/bin/bash

apt-get -y update && apt-get -y upgrade
apt-get -y install openssh-server screen python git openjdk-8-jdk android-tools-adb bc bison build-essential curl flex g++-multilib gcc-multilib gnupg gperf imagemagick lib32ncurses-dev lib32readline-dev lib32z1-dev  liblz4-tool libncurses5-dev libsdl1.2-dev libssl-dev libxml2 libxml2-utils lzop pngcrush rsync schedtool squashfs-tools xsltproc yasm zip zlib1g-dev libtinfo5 libncurses5
apt-get update --fix-missing
wget https://storage.googleapis.com/git-repo-downloads/repo -P /usr/local/sbin/
chmod +x /usr/local/sbin/repo