#!/bin/bash

# Just a basic script U can improvise lateron asper ur need xD 

MANIFEST="https://gitlab.com/OrangeFox/Manifest.git"
DEVICE=E
DT_LINK="https://github.com/MarvelMathesh/omni_device_10or_E -b OFRP"
DT_PATH=device/10or/$DEVICE

echo " ===+++ Setting up Build Environment +++==="
apt-get install openssh-server -y
apt-get update --fix-missing
apt-get install openssh-server -y
mkdir ~/ofox && cd ~/ofox

echo " ===+++ Syncing Recovery Sources +++==="
repo init --depth=1 -u $MANIFEST
repo sync
repo sync
git clone --depth=1 $DT_LINK $DT_PATH

echo " ===+++ Building Recovery +++==="
export ALLOW_MISSING_DEPENDENCIES=true
. build/envsetup.sh
echo " source build/envsetup.sh done"
lunch omni_${DEVICE}-eng || abort " lunch failed with exit status $?"
echo " lunch omni_${DEVICE}-eng done"
mka recoveryimage || abort " mka failed with exit status $?"
echo " mka recoveryimage done"

# Upload zips & recovery.img (U can improvise lateron adding telegram support etc etc)
echo " ===+++ Uploading Recovery +++==="

cd out/target/product/$DEVICE
curl -sL https://git.io/file-transfer | sh && ./transfer wet *.zip
