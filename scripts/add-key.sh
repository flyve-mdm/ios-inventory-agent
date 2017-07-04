#!/bin/sh

# Decrypt custom keychain
openssl aes-256-cbc -k "$KEYCHAIN_PASSWORD" -in $PROFILE_PATH/$PROFILE_UUID.mobileprovision.enc -d -a -out $PROFILE_PATH/$PROFILE_UUID.mobileprovision
openssl aes-256-cbc -k "$KEYCHAIN_PASSWORD" -in $CERTIFICATES_PATH/dist.cer.enc -d -a -out $CERTIFICATES_PATH/dist.cer
openssl aes-256-cbc -k "$KEYCHAIN_PASSWORD" -in $CERTIFICATES_PATH/dist.p12.enc -d -a -out $CERTIFICATES_PATH/dist.p12

# Create the keychain with a password
security create-keychain -p $KEYCHAIN_PASSWORD ios-build.keychain
security add-certificates -k ios-build.keychain $CERTIFICATES_PATH/apple.cer $CERTIFICATES_PATH/dist.cer

# Make the custom keychain default, so xcodebuild will use it for signing
# security list-keychains -d user -s ios-build.keychain
security default-keychain -s ios-build.keychain

# Unlock the keychain
security unlock-keychain -p $KEYCHAIN_PASSWORD ios-build.keychain

# Set keychain timeout to 1 hour for long builds
# see http://www.egeek.me/2013/02/23/jenkins-and-xcode-user-interaction-is-not-allowed/
security set-keychain-settings -t 3600 -l ~/Library/Keychains/ios-build.keychain

# Add certificates to keychain and allow codesign to access them
security import $CERTIFICATES_PATH/apple.cer -k ~/Library/Keychains/ios-build.keychain -T /usr/bin/codesign
security import $CERTIFICATES_PATH/dist.cer -k ~/Library/Keychains/ios-build.keychain -T /usr/bin/codesign
security import $CERTIFICATES_PATH/dist.p12 -k ~/Library/Keychains/ios-build.keychain -P "$KEYCHAIN_PASSWORD" -T /usr/bin/codesign

security set-key-partition-list -S apple-tool:,apple: -s -k $KEYCHAIN_PASSWORD ios-build.keychain

# Put the provisioning profile in place
mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles
cp "$PROFILE_PATH/$PROFILE_UUID.mobileprovision" ~/Library/MobileDevice/Provisioning\ Profiles/
