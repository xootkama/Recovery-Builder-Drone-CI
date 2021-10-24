#!/bin/bash

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
tg_post_msg "<b>Test Building XiaomiParts Apps...</b>%0A<b>DATE : </b><code>$DATE</code>%0A"

tg_post_msg "<b>===+++ Setting up Build Environment +++===</b>"
echo " ===+++ Setting up Build Environment +++==="
mkdir ~/xdroid && cd ~/xdroid
git config --global user.email jarbull87@gmail.com
git config --global user.name AnGgIt88
apt-get install openssh-server -y
apt-get update --fix-missing
apt-get install openssh-server -y

tg_post_msg "<b>===+++ Syncing Sources +++===</b>"
echo " ===+++ Syncing Rom Sources +++==="
repo init --depth=1 -u https://github.com/xdroid-CAF/xd_manifest -b eleven
git clone https://github.com/AnGgIt88/local_manifest.git --depth=1 -b eleven .repo/local_manifests
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j$(nproc --all)

tg_post_msg "<b>===+++ Starting Build +++===</b>"
echo " ===+++ Building Rom +++==="
export ALLOW_MISSING_DEPENDENCIES=true
export KBUILD_BUILD_USER=xiaomi
export KBUILD_BUILD_HOST=Finix-server
. build/envsetup.sh
lunch xdroid_rosy-userdebug
mmma /device/xiaomi/rosy/XiaomiParts

# Upload zips & Rom.img (U can improvise lateron adding telegram support etc etc)
tg_post_msg "<b>===+++ Uploading Rom +++===</b>"
echo " ===+++ Uploading Rom +++==="

# Push Rom to channel
    cd out/target/product/rosy/system/priv-app/XiaomiParts
    zip -r9 XiaomiParts.zip
    ZIP=$(echo *.zip)
    curl -F document=@$ZIP "https://api.telegram.org/bot$TG_TOKEN/sendDocument" \
        -F chat_id="$TG_CHAT_ID" \
        -F "disable_web_page_preview=true" \
        -F "parse_mode=html" 
