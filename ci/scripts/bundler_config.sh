#!/bin/sh

#   Copyright © 2017 Teclib. All rights reserved.
#
# bundler_config.sh is part of FlyveMDMInventoryAgent
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
# @date      25/08/17
# @copyright Copyright © 2017 Teclib. All rights reserved.
# @license   LGPLv3 https://www.gnu.org/licenses/lgpl-3.0.html
# @link      https://github.com/flyve-mdm/flyve-mdm-ios-inventory-agent
# @link      https://flyve-mdm.com
# ------------------------------------------------------------------------------

echo ----------- Configure bundler ------------
echo :update_sources: true >> ~/.gemrc
echo :benchmark: false >> ~/.gemrc
echo :backtrace: true >> ~/.gemrc
echo :verbose: true >> ~/.gemrc
echo gem: --no-ri --no-rdoc >> ~/.gemrc
echo install: --no-rdoc --no-ri >> ~/.gemrc
echo update: --no-rdoc --no-ri >> ~/.gemrc