#!/bin/sh +x

# TODO: karl optimization for downloading latest version without needing to hardcode version numbers. :+1:
# LATEST_MAC_DMG=$(curl -s https://ftp.mozilla.org/pub/mozilla.org/firefox/nightly/latest-trunk/ | fgrep en-US.mac.dmg | awk '{print $9}')
LATEST_MAC_DMG=$(curl -s https://ftp.mozilla.org/pub/mozilla.org/firefox/nightly/latest-trunk/ | fgrep en-US.mac.dmg | grep -Eo '\.dmg\">.+<\/a>' | sed -E "s/\.dmg\">(.+)<\/a>/\\1/")
curl -# -C - -o './LatestNightly.dmg' "https://ftp.mozilla.org/pub/mozilla.org/firefox/nightly/latest-trunk/$LATEST_MAC_DMG"


LATEST_MAC_TESTS=$(curl -s https://ftp.mozilla.org/pub/mozilla.org/firefox/nightly/latest-trunk/ | fgrep en-US.mac.common.tests.zip | grep -Eo '\.common\.tests\.zip\">.+<\/a>' | sed -E "s/\.common\.tests\.zip\">(.+)<\/a>/\\1/")
curl -# -C - -o './tests.zip' "https://ftp.mozilla.org/pub/mozilla.org/firefox/nightly/latest-trunk/$LATEST_MAC_TESTS"

mkdir mac_tests
unzip tests.zip -d mac_tests


# virtualenv setup
virtualenv marionette_env; source marionette_env/bin/activate
sudo pip install paramiko
sudo pip install marionette_client
sudo pip install six
sudo pip install pexpect
sudo pip install pyperclip


# virtualbox setup, assuming that openssh-server is installed in the vm
# VBoxManage modifyvm ubuntu-64-marionette --natpf1 "ssh,tcp,,3022,,22"
# VBoxManage showvminfo ubuntu-64-marionette | grep 'Rule'

VBoxManage startvm ubuntu-64-marionette


# run test
python control-script.py

VBoxManage controlvm ubuntu-64-marionette poweroff

# # ssh into virtualbox and send commands
# ssh -p 3022 kreamkorokke@127.0.0.1
deactivate

sudo rm -fr marionette_env
rm LatestNightly.dmg
rm tests.zip
rm -fr mac_tests
