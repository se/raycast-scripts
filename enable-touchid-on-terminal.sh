#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Enable TouchID on Terminal
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 🤖
# @raycast.argument1 { "type": "text", "placeholder": "Computer password", "secure": true }

# Documentation:
# @raycast.author Selcuk Ermaya
# @raycast.authorURL https://linkedin.com/in/selcukermaya

if grep -q 'auth sufficient pam_tid.so' /etc/pam.d/sudo; then
	echo "Touch ID is enabled for sudo"
else
	echo $1 | sudo -S grep -q -F 'auth sufficient pam_tid.so' /etc/pam.d/sudo || sudo sed -i '' '2i\
auth sufficient pam_tid.so
    ' /etc/pam.d/sudo
	if grep -q 'auth sufficient pam_tid.so' /etc/pam.d/sudo; then
		echo "'auth sufficient pam_tid.so' added to /etc/pam.d/sudo"
	fi
fi
