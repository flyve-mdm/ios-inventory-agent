#!/bin/sh

# Delete custom keychain
security delete-keychain $KEYCHAIN_NAME
rm -f "~/Library/MobileDevice/Provisioning\ Profiles/$PROFILE_UUID.mobileprovision"