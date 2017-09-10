#!/bin/sh

#   Copyright © 2017 Teclib. All rights reserved.
#
# before_test.sh is part of FlyveMDMInventoryAgent
#
# FlyveMDMInventoryAgent is a subproject of Flyve MDM. Flyve MDM is a mobile
# device management software.
#
# FlyveMDMInventoryAgent is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 3
# of the License, or (at your option) any later version.
#
# FlyveMDMInventoryAgent is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# ------------------------------------------------------------------------------
# @author    Hector Rondon
# @date      25/08/17
# @copyright Copyright © 2017 Teclib. All rights reserved.
# @license   GPLv3 https://www.gnu.org/licenses/gpl-3.0.html
# @link      https://github.com/flyve-mdm/flyve-mdm-ios-inventory-agent
# @link      https://flyve-mdm.com
# ------------------------------------------------------------------------------

echo ------------------- Configure Transifex --------------------
# Configure Transifex
if [[ ("$CIRCLE_BRANCH" == "develop" || "$CIRCLE_BRANCH" == "master") && "$CI_PULL_REQUEST" == "" ]]; then
    # Create config file transifex
    sudo echo $'[https://www.transifex.com]\nhostname = https://www.transifex.com\nusername = '"$TRANSIFEX_USER"$'\npassword = '"$TRANSIFEX_API_TOKEN"$'\ntoken = '"$TRANSIFEX_API_TOKEN"$'\n' > ~/.transifexrc
    
    # Move to local branch
    git checkout $CIRCLE_BRANCH -f
    # get transifex status
    tx status
    # push local files to transifex
    tx push -s -t
    # pull all the new language
    tx pull -a

    if [[ -n $GH_TOKEN ]]; then
        git config --global user.email $GH_EMAIL
        git config --global user.name "Flyve MDM"
        git remote remove origin
        git remote add origin https://$GH_USER:$GH_TOKEN@github.com/$TRAVIS_REPO_SLUG.git
    fi

    git add .
    git commit -m "ci(localization): download languages from **Transifex**"
    git push origin $CIRCLE_BRANCH
fi

echo ----------------- Decrypt custom keychain ------------------
# Decrypt custom keychain
openssl aes-256-cbc -k "$KEYCHAIN_PASSWORD" -in $PROFILE_PATH/$PROFILE_UUID.mobileprovision.enc -d -a -out $PROFILE_PATH/$PROFILE_UUID.mobileprovision
openssl aes-256-cbc -k "$KEYCHAIN_PASSWORD" -in $CERTIFICATES_PATH/dist.cer.enc -d -a -out $CERTIFICATES_PATH/dist.cer
openssl aes-256-cbc -k "$KEYCHAIN_PASSWORD" -in $CERTIFICATES_PATH/dist.p12.enc -d -a -out $CERTIFICATES_PATH/dist.p12
echo -------------Create the keychain with a password -----------
# Create the keychain with a password
security create-keychain -p $KEYCHAIN_PASSWORD $KEYCHAIN_NAME
security add-certificates -k $KEYCHAIN_NAME $CERTIFICATES_PATH/apple.cer $CERTIFICATES_PATH/dist.cer
echo ------------ Make the custom keychain default, so xcodebuild will use it for signing -------------
# Make the custom keychain default, so xcodebuild will use it for signing
security list-keychains -d user -s $KEYCHAIN_NAME
security default-keychain -s $KEYCHAIN_NAME
echo ------------------- Unlock the keychain --------------------
# Unlock the keychain
security unlock-keychain -p $KEYCHAIN_PASSWORD $KEYCHAIN_NAME
echo ----- Set keychain timeout to 1 hour for long builds -------
# Set keychain timeout to 1 hour for long builds
# see http://www.egeek.me/2013/02/23/jenkins-and-xcode-user-interaction-is-not-allowed/
security set-keychain-settings -t 3600 -l ~/Library/Keychains/$KEYCHAIN_NAME
echo -------------- Add certificates to keychain ----------------
# Add certificates to keychain and allow codesign to access them
security import $CERTIFICATES_PATH/apple.cer -k ~/Library/Keychains/$KEYCHAIN_NAME -T /usr/bin/codesign
security import $CERTIFICATES_PATH/dist.cer -k ~/Library/Keychains/$KEYCHAIN_NAME -T /usr/bin/codesign
security import $CERTIFICATES_PATH/dist.p12 -k ~/Library/Keychains/$KEYCHAIN_NAME -P "$KEYCHAIN_PASSWORD" -T /usr/bin/codesign

security set-key-partition-list -S apple-tool:,apple: -s -k $KEYCHAIN_PASSWORD $KEYCHAIN_NAME
echo -------------- Put the provisioning profile ----------------
# Put the provisioning profile in place
mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles
cp "$PROFILE_PATH/$PROFILE_UUID.mobileprovision" ~/Library/MobileDevice/Provisioning\ Profiles/
