#!/bin/bash

# Just a basic script U can improvise lateron asper ur need xD 

MANIFEST="https://gitlab.com/OrangeFox/sync.git"
DEVICE=ATOM
DT_LINK="https://github.com/OrangeFoxUnOfficial/fox_device_symphony_atom"
DT_PATH=device/symphony/$DEVICE

echo " ===+++ Setting up Build Environment +++==="
apt install openssh-server -y
apt update --fix-missing
apt install openssh-server -y
mkdir ~/twrp && cd ~/twrp

echo " ===+++ Sync OrangeFox +++==="
git clone $MANIFEST ~/FOX && cd ~/FOX
./orangefox_sync.sh --branch 10.0 --path ~/fox_10.0
cd ~/fox_10.0
git clone $DT_LINK $DT_PATH

echo " ====+++ Building OrangeFox +++==="
. build/envsetup.sh
export ALLOW_MISSING_DEPENDENCIES=true
export FOX_USE_TWRP_RECOVERY_IMAGE_BUILDER=1
export LC_ALL="C"
lunch omni_${DEVICE}-eng && mka recoveryimage

# Upload zips & recovery.img
#echo " ===+++ Uploading Recovery +++===
cd out/target/product/$DEVICE

curl -sL https://git.io/file-transfer | sh
./transfer wet *.zip
