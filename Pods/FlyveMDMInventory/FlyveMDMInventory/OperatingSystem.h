/*
 *   Copyright © 2017 Teclib. All rights reserved.
 *
 * OperatingSystem.h is part of FlyveMDMInventory
 *
 * FlyveMDMInventory is a subproject of Flyve MDM. Flyve MDM is a mobile
 * device management software.
 *
 * FlyveMDMInventory is Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * ------------------------------------------------------------------------------
 * @author    Hector Rondon
 * @date      15/06/17
 * @copyright Copyright © 2017 Teclib. All rights reserved.
 * @license   Apache License, Version 2.0 https://www.apache.org/licenses/LICENSE-2.0
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
