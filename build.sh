#!/bin/bash

# Just a basic script U can improvise lateron asper ur need xD 

MANIFEST="https://github.com/mastersenpai0405/platform_manifest_twrp_omni -b twrp-10.0"
DEVICE=KE5K
DT_LINK="https://github.com/mastersenpai0405/recovery_device_tecno_KE5K"
DT_PATH=device/tecno/$DEVICE

echo " ===+++ Setting up Build Environment +++==="
apt install openssh-server -y
apt update --fix-missing
apt install openssh-server -y
mkdir ~/twrp && cd ~/twrp

echo " ===+++ Syncing Recovery Sources +++==="
repo init --depth=1 -u $MANIFEST
repo sync
git clone $DT_LINK $DT_PATH

echo " ===+++ Building Recovery +++==="
. build/envsetup.sh
export ALLOW_MISSING_DEPENDENCIES=true
lunch omni_${DEVICE}-eng && mka recoveryimage

# Upload zips & recovery.img
echo " ===+++ Uploading Recovery +++==="
version=$(cat bootable/recovery/variables.h | grep "define TW_MAIN_VERSION_STR" | cut -d \" -f2)
OUTFILE=TWRP-${version}-${DEVICE}-$(date "+%Y%m%d-%I%M").zip

cd out/target/product/$DEVICE
mv recovery.img ${OUTFILE%.zip}.img
zip -r9 $OUTFILE ${OUTFILE%.zip}.img

#curl -T $OUTFILE https://oshi.at
curl -sL $OUTFILE https://git.io/file-transfer | sh
./transfer wet *.zip
