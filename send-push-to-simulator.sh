#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Send Push to Simulator
# @raycast.mode inline

# Optional parameters:
# @raycast.icon 📲
LAST_MODIFIED_FILE=`ls -tr $APNS_FOLDER | tail -n 1`
LAST_MODIFIED_FILE_FULLPATH=`echo $APNS_FOLDER/$LAST_MODIFIED_FILE`
PUSH_DEVICE_ID=`xcrun simctl list devices | grep 'Booted' | awk 'match($0, /\w{8}\-\w{4}\-\w{4}\-\w{4}\-\w{12}/);{print substr($5, 2, length($5)-2)}'`
xcrun simctl push $PUSH_DEVICE_ID dev.monofor.monoauth $LAST_MODIFIED_FILE_FULLPATH
echo "Push Sent to ($PUSH_DEVICE_ID). File is $LAST_MODIFIED_FILE"