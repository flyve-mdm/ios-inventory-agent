#!/bin/sh

#   LICENSE
#
# app_info.sh is part of FlyveMDMInventoryAgent
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
# @date      28/09/17
# @copyright Copyright © 2017-2018 Teclib. All rights reserved.
# @license   LGPLv3 https://www.gnu.org/licenses/lgpl-3.0.html
# @link      https://github.com/flyve-mdm/ios-inventory-agent.git
# @link      https://flyve-mdm.com
# ------------------------------------------------------------------------------

# Get version app
GIT_TAG=$(jq -r ".version" package.json)
# Update about.strings file
echo "\"version\" = \"$GIT_TAG\";" > "$APPNAME/about.strings"
echo "\"build\" = \"$CIRCLE_BUILD_NUM\";" >> "$APPNAME/about.strings"
echo "\"date\" = \"$(date "+%a %b %d %H:%M:%S %Y")\";" >> "$APPNAME/about.strings"
echo "\"commit\" = \"${CIRCLE_SHA1:0:7}\";" >> "$APPNAME/about.strings"
echo "\"commit_full\" = \"$CIRCLE_SHA1\";" >> "$APPNAME/about.strings"
# Add about.strings to git
git add -u
# Create commit
git commit -m "ci(build): update build info to version ${GIT_TAG}"
