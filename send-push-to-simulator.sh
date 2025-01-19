#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Send Push to Simulator
# @raycast.mode fullOutput
# @raycast.currentDirectoryPath /Users/code/git/se/raycast-scripts
# @raycast.needsConfirmation false

# Optional parameters:
# @raycast.icon 📲

LAST_MODIFIED_FILE=$(ls -tr $APNS_FOLDER | tail -n 1)
LAST_MODIFIED_FILE_FULLPATH=$(echo $APNS_FOLDER/$LAST_MODIFIED_FILE)
PUSH_DEVICE_IDS=$(xcrun simctl list devices | grep 'Booted' | grep -oE '[0-9A-F\-]{36}')

for CURRENT_ID in $PUSH_DEVICE_IDS; do
	echo "Sending Push to ($CURRENT_ID). File is $LAST_MODIFIED_FILE"
	xcrun simctl push "$CURRENT_ID" dev.monofor.monoauth "$LAST_MODIFIED_FILE_FULLPATH"
	echo "Push Sent to ($CURRENT_ID). File is $LAST_MODIFIED_FILE"
done
