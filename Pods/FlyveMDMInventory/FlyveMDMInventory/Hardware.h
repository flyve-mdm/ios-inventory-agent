/*
 *   Copyright © 2017 Teclib. All rights reserved.
 *
 * Hardware.h is part of FlyveMDMInventory
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
 * @date      13/06/17
 * @copyright Copyright © 2017 Teclib. All rights reserved.
 * @license   Apache License, Version 2.0 https://www.apache.org/licenses/LICENSE-2.0
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
