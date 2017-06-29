/*
 *   Copyright © 2017 Teclib. All rights reserved.
 *
 * OperatingSystem.h is part of FlyveMDMInventory
 *
 * FlyveMDMInventory is a subproject of Flyve MDM. Flyve MDM is a mobile
 * device management software.
 *
 * FlyveMDMInventory is free software: you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 3
 * of the License, or (at your option) any later version.
 *
 * FlyveMDMInventory is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * ------------------------------------------------------------------------------
 * @author    Hector Rondon
 * @date      15/06/17
 * @copyright Copyright © 2017 Teclib. All rights reserved.
 * @license   GPLv3 https://www.gnu.org/licenses/gpl-3.0.html
 * @link      https://github.com/flyve-mdm/flyve-mdm-ios-inventory
 * @link      https://flyve-mdm.com
 * ------------------------------------------------------------------------------
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface OperatingSystem: NSObject

/**
 Operating System Name
 
 - returns: Operating system name of Device string
 */
- (nullable NSString *)name;

/**
 Operating System Full Name
 
 - returns: Operating system full name of Device string
 */
- (nullable NSString *)fullName;

/**
 Operating System Version
 
 - returns: Operating system version of Device string
 */
- (nullable NSString *)version;

/**
 Operating System Build
 
 - returns: Operating system build of Device string
 */
- (nullable NSString *)build;

/**
 Operating System Kernel Name
 
 - returns: Operating system kernel name of Device string
 */
- (nullable NSString *)kernelName;

/**
 Operating System Kernel Version
 
 - returns: Operating system kernel version of Device string
 */
- (nullable NSString *)kernelVersion;


@end
