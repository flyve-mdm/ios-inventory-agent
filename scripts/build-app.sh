#!/bin/sh

# Clear xcworkspace
xcodebuild -workspace FlyveMDMInventoryAgent.xcworkspace -scheme FlyveMDMInventoryAgent -destination generic/platform=iOS clean

# Create Archive
#xcodebuild -workspace FlyveMDMInventoryAgent.xcworkspace -scheme FlyveMDMInventoryAgent -sdk iphoneos -configuration Release archive -archivePath $PWD/build/FlyveMDMInventoryAgent.xcarchive OTHER_CODE_SIGN_FLAGS="--keychain ~/Library/Keychains/ios-build.keychain" CODE_SIGN_IDENTITY="iPhone Distribution: s42, C.A. (G3UM9C856M)"
