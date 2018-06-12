#!/bin/sh

#   LICENSE
#
# git_config.sh is part of FlyveMDMInventoryAgent
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

if [[ -n $GITHUB_TOKEN ]]; then
    git config --global user.email $GITHUB_EMAIL
    git config --global user.name "Flyve MDM"
    git remote remove origin
    git remote add origin https://$GITHUB_USER:$GITHUB_TOKEN@github.com/$CIRCLE_PROJECT_USERNAME/$CIRCLE_PROJECT_REPONAME.git
fi
