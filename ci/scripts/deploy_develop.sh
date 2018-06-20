#!/bin/sh

#   LICENSE
#
# deploy_develop.sh is part of FlyveMDMInventoryAgent
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
# @author    Hector Rondon <hrondon@teclib.com>
# @date      08/09/17
# @copyright Copyright © 2017-2018 Teclib. All rights reserved.
# @license   LGPLv3 https://www.gnu.org/licenses/lgpl-3.0.html
# @link      https://github.com/flyve-mdm/ios-inventory-agent.git
# @link      http://flyve.org/ios-inventory-agent
# @link      https://flyve-mdm.com
# ------------------------------------------------------------------------------

GITHUB_COMMIT_MESSAGE=$(git log --format=oneline -n 1 $CIRCLE_SHA1)

if [[ $GITHUB_COMMIT_MESSAGE != *"ci(release): generate CHANGELOG.md for version"* && $GITHUB_COMMIT_MESSAGE != *"ci(build): release version"* ]]; then
    echo "Generate CHANGELOG.md and increment version"
    # Get gh=pages branch
    git fetch origin gh-pages
    # Generate CHANGELOG.md and increment version
    yarn standard-version -- -t ''
    # Get version number from package.json
    export GIT_TAG=$(jq -r ".version" package.json)
    # Update CFBundleShortVersionString
    /usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString ${GIT_TAG}" ${PWD}/${APPNAME}/Info.plist
    # Update CFBundleVersion
    /usr/libexec/PlistBuddy -c "Set :CFBundleVersion $CIRCLE_BUILD_NUM" ${PWD}/${APPNAME}/Info.plist
    # Add modified and delete files
    git add ${APPNAME}/Info.plist
    # Create commit
    git commit -m "ci(beta): generate **beta** for version ${GIT_TAG}"

    echo "Generate documentation with jazzy"
    # Generate documentation with jazzy
    jazzy
    mv docs/ code-documentation/  
    # Add docs folder
    git add code-documentation -f
    # Create commit, NOTICE: this commit is not sent
    git commit -m "ci(docs): generate **docs** for version ${GIT_TAG}"
    # Update documentation on gh-pages branch
    yarn gh-pages --dist code-documentation --dest development/code-documentation -m "ci(docs): generate documentation with jazzy for version ${GIT_TAG}"

    echo "Generate code coverage reporting with xcov"
    # Generate code coverage reporting with xcov
    bundle exec fastlane coverage

    # Add coverage folder
    git add coverage -f
    # Create commit, NOTICE: this commit is not sent
    git commit -m "ci(docs): generate **coverage** for version ${GIT_TAG}"
    # Update coverage on gh-pages branch
    yarn gh-pages --dist coverage --dest coverage -m "ci(docs): generate coverage with xcov for version ${GIT_TAG}"

    echo "Generate screenshots"
    # Generate screenshots
    bundle exec fastlane snapshot
    
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
    git add screenshots -f
    # Create commit, NOTICE: this commit is not sent
    git commit -m "ci(snapshot): generate **snapshot** for version ${GIT_TAG}"
    # Update coverage on gh-pages branch
    yarn gh-pages --dist screenshots --dest screenshots -m "ci(snapshot): generate screenshots for version ${GIT_TAG}"

    # Send untracked files to stash
    git add .
    git stash
    # Checkout to gh-pages branch
    git checkout gh-pages
    git pull origin gh-pages

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

    git checkout $CIRCLE_BRANCH -f
    git stash apply stash@{0}
    # Update app info
    source "${SCRIPT_PATH}/app_info.sh"
    # Send app to TestFligth
    bundle exec fastlane beta
fi