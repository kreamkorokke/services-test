#!/usr/bin/env python
# -*- coding: utf-8 -*-

import pexpect
import sys
import re
import paramiko

from password import *

# def main():
# 	# spin up the caller test case and get the room url
# 	caller = pexpect.spawn("bash")
# 	caller.logfile = sys.stdout
# 	caller.sendline("cd ../firefox-42.0a1.en-US.mac.tests/marionette/marionette; python runtests.py --binary=/Applications/Firefox.app/Contents/MacOS/firefox-bin --address=localhost:2828 --type=browser ../../../loop-e2e-test/caller_case.ini")
# 	caller.expect("Give a GO sign")
# 	match = re.search("The\sroom\surl\sis:\s(http.+)", caller.before)
# 	room_url = match.group(1)

# 	# spin up the recipient test case to join the room
# 	recipient = pexpect.spawn("bash")
# 	recipient.logfile = sys.stdout
# 	recipient.sendline("cd ../firefox-42.0a1.en-US.mac.tests/marionette/marionette; python runtests.py --binary=/Applications/Firefox.app/Contents/MacOS/firefox-bin --address=localhost:2829 --type=browser ../../../loop-e2e-test/recipient_case.ini")
# 	recipient.sendline(room_url)
# 	recipient.expect("Done?")

# 	# room established, kill test cases
# 	caller.sendline("GO")
# 	recipient.sendline("done")

def main():
	# spin up the caller test case and get the room url
	caller = pexpect.spawn("bash")
	caller.logfile = sys.stdout
	caller.sendline("cd ./mac_tests/marionette/marionette; python runtests.py --binary=/Applications/Firefox.app/Contents/MacOS/firefox-bin --address=localhost:2828 --type=browser ../../../caller_case.ini")
	caller.expect("Give a GO sign")
	match = re.search("The\sroom\surl\sis:\s(http.+)", caller.before)
	room_url = match.group(1)

	# ssh into the virtualbox
	ssh = paramiko.SSHClient()
	ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
	ssh.connect('127.0.0.1', username='kreamkorokke', password=PASSWORD, port=3022)

	stdin, stdout, stderr = ssh.exec_command("cd ./Documents; ls -a")

	print(stdout.readlines())

	ssh.close()

	caller.sendline("GO")


if __name__ == "__main__":
	main()