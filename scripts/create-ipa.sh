#!/bin/sh

# Create IPA file
xcodebuild -exportArchive -archivePath ./build/FlyveMDMInventoryAgent.xcarchive -exportPath ./build -exportOptionsPlist $SCRIPT_PATH/exportPlist.plist
