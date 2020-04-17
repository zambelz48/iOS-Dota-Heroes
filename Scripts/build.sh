#!/bin/bash

ROOT_DIR="$(pwd)"

source "$ROOT_DIR/Scripts/utils.sh"
source "$ROOT_DIR/Scripts/required-tools.sh"
source "$ROOT_DIR/Scripts/install-dependencies.sh"

DERIVEDDATA_DIR="$HOME/iOSBoilerPlateDerivedData"
PROJECT="$ROOT_DIR/App.xcodeproj"
SDK="iphonesimulator13.4"
PLATFORM="platform=iOS Simulator,OS=13.4,name=iPhone 11"
TARGET_SCHEME="Production"

createDirectory "$DERIVEDDATA_DIR"

echo "Clean derived data..."
clearDataInDirectory "$DERIVEDDATA_DIR"

set -o pipefail && xcodebuild \
	-project "$PROJECT" \
	-sdk "$SDK" \
	-destination "$PLATFORM" \
	-derivedDataPath "$DERIVEDDATA_DIR" \
	-scheme "$TARGET_SCHEME" \
	build-for-testing test | xcpretty
