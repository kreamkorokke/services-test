#!/bin/sh +x


cd ./Documents

curl -# -C - -o './get-pip.py' "https://bootstrap.pypa.io/get-pip.py"
sudo python get-pip.py

virtualenv marionette_env; source marionette_env/bin/activate
sudo pip install paramiko
sudo pip install marionette_client
sudo pip install six
sudo pip install pexpect
sudo pip install pyperclip


LATEST_LINUX_DMG=$(curl -s https://ftp.mozilla.org/pub/mozilla.org/firefox/nightly/latest-trunk/ | fgrep en-US.linux-x86_64.tar.bz2 | grep -Eo '\.linux\-x86\_64\.tar\.bz2\">.+<\/a>' | sed -E "s/\.linux\-x86\_64\.tar\.bz2\">(.+)<\/a>/\\1/")
curl -# -C - -o './LatestNightly.tar.bz2' "https://ftp.mozilla.org/pub/mozilla.org/firefox/nightly/latest-trunk/$LATEST_LINUX_DMG"

LATEST_LINUX_TESTS=$(curl -s https://ftp.mozilla.org/pub/mozilla.org/firefox/nightly/latest-trunk/ | fgrep en-US.linux-x86_64.common.tests.zip | grep -Eo '\.linux\-x86\_64\.common\.tests\.zip\">.+<\/a>' | sed -E "s/\.linux\-x86\_64\.common\.tests\.zip\">(.+)<\/a>/\\1/")
curl -# -C - -o './linux_tests.zip' "https://ftp.mozilla.org/pub/mozilla.org/firefox/nightly/latest-trunk/$LATEST_LINUX_TESTS"

tar -xjvf *.bz2 -C /home/ubuntu

mkdir linux_tests
unzip ./linux_tests.zip -d linux_tests
