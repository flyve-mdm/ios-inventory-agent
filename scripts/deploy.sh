#!/bin/sh

#   Copyright © 2017 Teclib. All rights reserved.
#
# deploy.sh is part of flyve-mdm-ios
#
# flyve-mdm-ios is a subproject of Flyve MDM. Flyve MDM is a mobile
# device management software.
#
# flyve-mdm-ios is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 3
# of the License, or (at your option) any later version.
#
# flyve-mdm-ios is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# ------------------------------------------------------------------------------
# @author    Hector Rondon
# @date      03/09/17
# @copyright Copyright © 2017 Teclib. All rights reserved.
# @license   GPLv3 https://www.gnu.org/licenses/gpl-3.0.html
# @link      https://github.com/flyve-mdm/flyve-mdm-ios-inventory-agent
# @link      https://flyve-mdm.com
# ------------------------------------------------------------------------------

if [[ -n $GH_TOKEN ]]; then
    git config --global user.email $GH_EMAIL
    git config --global user.name "Flyve MDM"
    git remote remove origin
    git remote add origin https://$GH_USER:$GH_TOKEN@github.com/$TRAVIS_REPO_SLUG.git
fi

if [[ "$TRAVIS_BRANCH" == "develop" && "$TRAVIS_PULL_REQUEST" == "false" ]]; then

    if [[ $TRAVIS_COMMIT_MESSAGE != *"**beta**"* ]]; then
        git checkout $TRAVIS_BRANCH -f
        # Generate CHANGELOG.md and increment version
        npm run release -- -t ''
        # Get version number from package.json
        export GIT_TAG=$(jq -r ".version" package.json)
        # Revert last commit
        git reset --hard HEAD~1
        # Update CFBundleShortVersionString
        /usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString ${GIT_TAG}" ${PWD}/${APPNAME}/Info.plist
        # Update CFBundleVersion
        /usr/libexec/PlistBuddy -c "Set :CFBundleVersion $TRAVIS_BUILD_NUMBER" ${PWD}/${APPNAME}/Info.plist
        # Add modified and delete files
        git add ${APPNAME}/Info.plist
        # Create commit
        git commit -m "ci(beta): generate **beta** for version ${GIT_TAG}"
        # Push commits to origin branch
        git push origin $TRAVIS_BRANCH

        # Generate documentation with jazzy
        jazzy \
        --clean \
        --author Flyve MDM \
        --author_url https://flyve-mdm.com \
        --github_url https://github.com/$TRAVIS_REPO_SLUG \
        --output _docs \
        --theme jazzy/themeFlyve

        # Add _docs folder
        git add _docs -f
        # Create commit, NOTICE: this commit is not sent
        git commit -m "ci(docs): generate **docs** for version ${GIT_TAG}"

        # Run fastlane test
        fastlane test

        # Generate code coverage reporting with xcov
        xcov \
        --workspace ${APPNAME}.xcworkspace \
        --scheme ${APPNAME} \
        --output_directory coverage \
        --html_report \
        --only_project_targets

        # Add coverage folder
        git add coverage -f
        # Create commit, NOTICE: this commit is not sent
        git commit -m "ci(docs): generate **coverage** for version ${GIT_TAG}"

        # Update documentation on gh-pages
        git fetch origin gh-pages
        git checkout gh-pages
        git checkout $TRAVIS_BRANCH _docs

        # Add _docs folder
        git add CHANGELOG.md
        # Create commit
        git commit -m "ci(docs): generate documentation with jazzy for version ${GIT_TAG}"
        # Push commit to origin gh-pages branch

        # Get code coverage from develop branch
        git checkout $TRAVIS_BRANCH coverage
        # Add coverage folder
        git add coverage
        # Create commit
        git commit -m "ci(docs): generate coverage with xcov for version ${GIT_TAG}"
        
        # Push commit to origin gh-pages branch
        git push origin gh-pages

        fastlane beta
    fi

elif [[ "$TRAVIS_BRANCH" == "master" && "$TRAVIS_PULL_REQUEST" == "false" ]]; then

    if [[ $TRAVIS_COMMIT_MESSAGE != *"**version**"* && $TRAVIS_COMMIT_MESSAGE != *"**CHANGELOG.md**"* ]]; then
        git checkout $TRAVIS_BRANCH -f
        # Generate CHANGELOG.md and increment version
        npm run release -- -t '' -m "ci(release): generate **CHANGELOG.md** for version %s"
        # Push tag to github
        # conventional-github-releaser -t $GH_TOKEN -r 0
        # Get version number from package.json
        export GIT_TAG=$(jq -r ".version" package.json)
        # Update CFBundleShortVersionString
        /usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString ${GIT_TAG}" ${PWD}/${APPNAME}/Info.plist
        # Update CFBundleVersion
        /usr/libexec/PlistBuddy -c "Set :CFBundleVersion $TRAVIS_BUILD_NUMBER" ${PWD}/${APPNAME}/Info.plist
        # Add modified and delete files
        git add -u
        # Create commit
        git commit -m "ci(build): release **version** ${GIT_TAG}"
        # Push commits and tags to origin branch
        git push --follow-tags origin $TRAVIS_BRANCH

        # Update CHANGELOG.md on gh-pages
        git fetch origin gh-pages
        git checkout gh-pages
        git checkout $TRAVIS_BRANCH CHANGELOG.md

        # Create header content
        HEADER="---\nlayout: modal\ntitle: changelog\n---\n"
        # Duplicate CHANGELOG.md
        cp CHANGELOG.md CHANGELOG_COPY.md
        # Add header to CHANGELOG.md
        (echo $HEADER ; cat CHANGELOG_COPY.md) > CHANGELOG.md
        # Remove CHANGELOG_COPY.md
        rm CHANGELOG_COPY.md

        # Add CHANGELOG.md
        git add CHANGELOG.md
        # Create commit
        git commit -m "ci(docs): generate CHANGELOG.md for version ${GIT_TAG}"
        # Push commit to origin gh-pages branch
        git push origin gh-pages

        fastlane release
    fi
fi
