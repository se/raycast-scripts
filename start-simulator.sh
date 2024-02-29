#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Open a Simulator
# @raycast.mode fullOutput
# @raycast.currentDirectoryPath /Users/code/git/se/raycast-scripts
# @raycast.needsConfirmation false

# Optional parameters:
# @raycast.icon 📱
# @raycast.argument1 { "type": "text", "placeholder": "Device Name", "secure": false }

DEVICE_NAME=$(echo $1 | awk '{print tolower($0)}')

device_line=$(xcrun simctl list devices available | grep -i "$DEVICE_NAME" | head -n 1)

if [ -z "$device_line" ]; then
	echo "$DEVICE_NAME device not found."
	exit 1
fi

device_uuid=$(echo $device_line | awk -F '[()]' '{print $2}')

if [ -z "$device_uuid" ]; then
	echo "Device UUID not found: $DEVICE_NAME"
	exit 1
fi

echo "Starting the device $DEVICE_NAME ($device_uuid)"

xcrun simctl boot "$device_uuid"

open -a Simulator

echo "$DEVICE_NAME started."
