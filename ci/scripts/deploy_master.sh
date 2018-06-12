#!/bin/sh

#   Copyright © 2017 Teclib. All rights reserved.
#
# deploy_master.sh is part of FlyveMDMInventoryAgent
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
# @date      09/09/17
# @copyright Copyright © 2017 Teclib. All rights reserved.
# @license   LGPLv3 https://www.gnu.org/licenses/lgpl-3.0.html
# @link      https://github.com/flyve-mdm/flyve-mdm-ios-inventory-agent
# @link      https://flyve-mdm.com
# ------------------------------------------------------------------------------

GITHUB_COMMIT_MESSAGE=$(git log --format=oneline -n 1 $CIRCLE_SHA1)

if [[ $GITHUB_COMMIT_MESSAGE != *"ci(release): generate CHANGELOG.md for version"* && $GITHUB_COMMIT_MESSAGE != *"ci(build): release version"* ]]; then
    echo "Generate CHANGELOG.md and increment version"
    # Generate CHANGELOG.md and increment version
    yarn standard-version -t '' -m "ci(release): generate CHANGELOG.md for version %s"
    # Get version number from package.json
    export GIT_TAG=$(jq -r ".version" package.json)
    # Update CFBundleShortVersionString
    /usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString ${GIT_TAG}" ${PWD}/${APPNAME}/Info.plist
    # Update CFBundleVersion
    /usr/libexec/PlistBuddy -c "Set :CFBundleVersion $CIRCLE_BUILD_NUM" ${PWD}/${APPNAME}/Info.plist
    # Add modified and delete files
    git add -u
    # Create commit
    git commit -m "ci(build): release version ${GIT_TAG}"
    # Push commits and tags to origin branch
    git push --follow-tags origin $CIRCLE_BRANCH
    echo "Create release with conventional-github-releaser"
    # Create release with conventional-github-releaser
    yarn conventional-github-releaser -p angular -t $GITHUB_TOKEN
    # Update app info
    source "${SCRIPT_PATH}/app_info.sh"
    echo "Archive app"
    # Archive app
    bundle exec fastlane archive
    echo "Generate screenshots"
    # Add screenshots folder
    git add fastlane/screenshots -f
    # Create commit, NOTICE: this commit is not sent
    git commit -m "ci(snapshot): generate **snapshot** for version ${GIT_TAG}"

    echo "Upload ipa file to release"
    # Upload ipa file to release
    yarn github-release upload \
    --user $CIRCLE_PROJECT_USERNAME \
    --repo $CIRCLE_PROJECT_REPONAME \
    --tag ${GIT_TAG} \
    --name "${APPNAME}.ipa" \
    --file "${APPNAME}.ipa"

    echo "Update CHANGELOG.md on gh-pages"
    # Update CHANGELOG.md on gh-pages
    git fetch origin gh-pages
    git checkout gh-pages
    git checkout $CIRCLE_BRANCH CHANGELOG.md

    # Create header content to CHANGELOG.md
    echo "---" > header.md
    echo "layout: modal" >> header.md
    echo "title: changelog" >> header.md
    echo "---" >> header.md

    # Duplicate CHANGELOG.md
    cp CHANGELOG.md CHANGELOG_COPY.md
    # Add header to CHANGELOG.md
    (cat header.md ; cat CHANGELOG_COPY.md) > CHANGELOG.md
    # Remove CHANGELOG_COPY.md
    rm CHANGELOG_COPY.md
    rm header.md

    # Add CHANGELOG.md
    git add CHANGELOG.md
    # Create commit
    git commit -m "ci(docs): generate CHANGELOG.md for version ${GIT_TAG}"

    echo "Update screenshots"
    # Remove old screenshots
    rm -rf screenshots
    
    git checkout $CIRCLE_BRANCH fastlane/screenshots
    mv fastlane/screenshots/ screenshots/

    # Create header content to screenshots
    echo "---" > header.html
    echo "layout: container" >> header.html
    echo "namePage: screenshots" >> header.html
    echo "---" >> header.html

    # Add header to CHANGELOG.md
    (cat header.html ; cat screenshots/screenshots.html) > screenshots/index.html
    # Remove CHANGELOG_COPY.md
    rm screenshots/screenshots.html
    rm header.html

    # Add screenshots folder
    git add fastlane/screenshots/
    git add screenshots
    # Create commit
    git commit -m "ci(snapshot): generate screenshots for version ${GIT_TAG}"

    echo "Update cache"
    # Create header content to cache
    echo "---" > header_cache
    echo "cache_version: $CIRCLE_SHA1" >> header_cache
    echo "---" >> header_cache
    # Remove header from file
    sed -e '1,3d' sw.js > cache_file
    rm sw.js
    # Add new header
    (cat header_cache ; cat cache_file) > sw.js
    # Remove temp files
    rm cache_file
    rm header_cache
    # Add sw.js to git
    git add -u
    # Create commit
    git commit -m "ci(cache): force update cache for version ${GIT_TAG}"

    # Push commit to origin gh-pages branch
    git push origin gh-pages

    # Update develop branch
    git fetch origin develop
    git checkout develop
    # Merge master on develop
    git rebase master
    git push origin develop

    # Checkout to release branch
    git checkout $CIRCLE_BRANCH -f
    # Send app to App Store with fastlane 
    bundle exec fastlane publish
fi
