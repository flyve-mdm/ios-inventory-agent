/*
 *   Copyright © 2017 Teclib. All rights reserved.
 *
 * Hardware.h is part of FlyveMDMInventory
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
 * @date      13/06/17
 * @copyright Copyright © 2017 Teclib. All rights reserved.
 * @license   GPLv3 https://www.gnu.org/licenses/gpl-3.0.html
 * @link      https://github.com/flyve-mdm/flyve-mdm-ios-inventory
 * @link      https://flyve-mdm.com
 * ------------------------------------------------------------------------------
 */

#import <Foundation/Foundation.h>
/// Hardware Information
@interface Hardware : NSObject

/**
 Device ID
 
 - returns: Device ID string
 */
- (nullable NSString *)uuid;

/**
 Device Name
 
 - returns: Device name string
 */
- (nullable NSString *)name;

/**
 Model of Device
 
 - returns: Model of Device string
 */
- (nullable NSString *)model;

/**
 Identifier of Device
 
 - returns: Identifier of Device string
 */
- (nullable NSString *)identifier;

/**
 Operating System Type
 
 - returns: Operating system type of Device string
 */
- (nullable NSString *)osType;

/**
 Operating System Version
 
 - returns: Operating system version of Device string
 */
- (nullable NSString *)osVersion;

/**
 System architecture name
 
 - returns: System architecture name of Device string
 */
- (nullable NSString *)archName;

/**
 GPU Vendor name
 
 - returns: GPU Vendor of Device string
 */
- (nullable NSString *)gpuVendor;

/**
 GPU Version name
 
 - returns: GPU Version of Device string
 */
- (nullable NSString *)gpuVersion;

/**
 Screen Resolution size
 
 - returns: Screen Resolution size of Device string
 */
- (nullable NSString *)screenResolution;

/**
 Front Camera Resolution size
 
 - returns: Front Camera Resolution size of Device string
 */
- (nullable NSString *)frontCamera;

/**
 Back Camera Resolution size
 
 - returns: Back Camera Resolution size of Device string
 */
- (nullable NSString *)backCamera;

@end
