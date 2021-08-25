#!/bin/bash

export TG_CHAT_ID=-1001580307414
export TG_TOKEN=1852697615:AAGKDF9cYNnTY4Ylm7XjBrsssS31eTtqYfk

# Just a basic script U can improvise lateron asper ur need xD 

# Function to show an informational message
msg() {
    echo -e "\e[1;32m$*\e[0m"
}

err() {
    echo -e "\e[1;41m$*\e[0m"
}

DATE=$(date +"%F-%S")
START=$(date +"%s")

# Inlined function to post a message
export BOT_MSG_URL="https://api.telegram.org/bot$TG_TOKEN/sendMessage"
tg_post_msg() {
	curl -s -X POST "$BOT_MSG_URL" -d chat_id="$TG_CHAT_ID" \
	-d "disable_web_page_preview=true" \
	-d "parse_mode=html" \
	-d text="$1"

}

tg_post_build() {
	curl --progress-bar -F document=@"$1" "$BOT_MSG_URL" \
	-F chat_id="$TG_CHAT_ID"  \
	-F "disable_web_page_preview=true" \
	-F "parse_mode=html" \
	-F caption="$3"
}

# Send a notificaton to TG
tg_post_msg "<b>Rom Compilation Started...</b>%0A<b>DATE : </b><code>$DATE</code>%0A"

tg_post_msg "<b>===+++ Setting up Build Environment +++===</b>"
echo " ===+++ Setting up Build Environment +++==="
apt-get install openssh-server -y
apt-get update --fix-missing
apt-get install openssh-server -y
mkdir ~/dotOS && cd ~/dotOS

tg_post_msg "<b>===+++ Syncing Rom Sources +++===</b>"
echo " ===+++ Syncing Rom Sources +++==="
repo init --depth=1 -u $MANIFEST
repo sync
git clone --depth=1 $DT_LINK -b $BRANCH $DT_PATH
git clone --depth=1 $VT_LINK -b $VT_BRANCH $VT_PATH
git clone --depth=1 $KT_LINK -b $KT_BRANCH $KT_PATH
git clone --depth=1 $TC_LINK -b $TC_BRANCH $TC_PATH
git clone --depth=1 $TC32_LINK -b $TC32_BRANCH $TC32_PATH
cd system/sepolicy
git fetch "https://github.com/LineageOS/android_system_sepolicy" refs/changes/44/292244/3 && git cherry-pick FETCH_HEAD && cd ../..

tg_post_msg "<b>===+++ Starting Build Rom +++===</b>"
echo " ===+++ Building Rom +++==="
export ALLOW_MISSING_DEPENDENCIES=true
export KBUILD_BUILD_USER=xiaomi
export KBUILD_BUILD_HOST=Finix-server
. build/envsetup.sh
echo " source build/envsetup.sh done"
lunch dot_${DEVICE}-userdebug || abort " lunch failed with exit status $?"
echo " lunch dot_${DEVICE}-userdebug done"
make bacon || abort " make failed with exit status $?"
echo " make done"

# Upload zips & Rom.img (U can improvise lateron adding telegram support etc etc)
tg_post_msg "<b>===+++ Uploading Rom +++===</b>"
echo " ===+++ Uploading Rom +++==="

# Push Rom to channel
    cd out/target/product/$DEVICE
    ZIP=$(echo dotOS-*.zip)
    curl -F document=@$ZIP "https://api.telegram.org/bot$TG_TOKEN/sendDocument" \
        -F chat_id="$TG_CHAT_ID" \
        -F "disable_web_page_preview=true" \
        -F "parse_mode=html" 