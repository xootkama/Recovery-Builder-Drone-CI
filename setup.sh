#!/bin/bash

apt-get -y update && apt-get -y upgrade
apt-get -y install openssh-server
apt-get -y update --fix-missing
