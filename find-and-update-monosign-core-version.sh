#!/bin/bash
# git pull

# Find the execution directory
EXEC_DIR="$(pwd)"

# Read the VERSION from VERSION.file
MONOSIGN_DIR="$EXEC_DIR/../../monosign"
VERSION_FILE="$MONOSIGN_DIR/core/VERSION"

if [[ -f "$VERSION_FILE" ]]; then
    VERSION="$(cat "$VERSION_FILE" | tr -d '[:space:]')"
else
    echo "Error: VERSION file not found in the execution directory."
    exit 1
fi

# Find the dependencies.props file
DEPS_FILE="$EXEC_DIR/dependencies.props"

echo "Found dependencies.props file: $DEPS_FILE"

# Replace the <MonoSignCoreVersion>$VERSION</MonoSignCoreVersion> with the given VERSION
if [[ -f "$DEPS_FILE" ]]; then
	OLD_VERSION="$(sed -n 's#<MonoSignCoreVersion>\([^<]*\)</MonoSignCoreVersion>#\1#p' "$DEPS_FILE" | tr -d '[:space:]')"
    echo "OLD version: $OLD_VERSION"
    echo "NEW version: $VERSION"

	if [[ "$OLD_VERSION" == "$VERSION" ]]; then
		echo "No need to update the version. The version is already $VERSION"
		exit 0
	fi

    TEMP_FILE="$(mktemp)"
    sed "s#<MonoSignCoreVersion>.*</MonoSignCoreVersion>#<MonoSignCoreVersion>$VERSION</MonoSignCoreVersion>#" "$DEPS_FILE" > "$TEMP_FILE"
    mv "$TEMP_FILE" "$DEPS_FILE"
    echo "Updated dependencies.props with the new version: $VERSION (Old version $OLD_VERSION)"
else
    echo "Error: dependencies.props not found in the execution directory."
    exit 2
fi
git add . && git commit  -m "Core version update $OLD_VERSION to $VERSION"