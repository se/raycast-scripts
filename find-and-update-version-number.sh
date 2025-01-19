#!/bin/bash
# git pull

# Find the execution directory
EXEC_DIR="$(pwd)"

# Read the VERSION from VERSION.file
VERSION_FILE="./VERSION"

if [[ -f "$VERSION_FILE" ]]; then
    VERSION="$(cat "$VERSION_FILE" | tr -d '[:space:]')"
else
    echo "Error: VERSION file not found in the execution directory."
    exit 1
fi

echo "Current version: $VERSION"
NEW_VERSION=$(echo $VERSION | awk -F. '{$NF = $NF + 1;} 1' | sed 's/ /./g')
echo "Current version: $NEW_VERSION"
echo "Writing to the file VERSION"
echo $NEW_VERSION >$VERSION_FILE
git add . && git commit -m "Version updated from $VERSION to $NEW_VERSION"
