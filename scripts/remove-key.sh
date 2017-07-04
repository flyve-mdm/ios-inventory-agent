#!/bin/sh

# Delete custom keychain
security delete-keychain ios-build.keychain
rm -f "~/Library/MobileDevice/Provisioning\ Profiles/$PROFILE_UUID.mobileprovision"