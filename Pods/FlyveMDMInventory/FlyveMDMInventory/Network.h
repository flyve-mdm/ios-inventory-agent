/*
 *   LICENSE
 *
 * Network.h is part of FlyveMDMInventory
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
 * @author    Hector Rondon <hrondon@teclib.com>
 * @date      13/06/17
 * @copyright Copyright © 2017-2018 Teclib. All rights reserved.
 * @license   Apache License, Version 2.0 https://www.apache.org/licenses/LICENSE-2.0
 * @link      https://github.com/flyve-mdm/flyve-mdm-ios-inventory
 * @link      https://flyve-mdm.com
 * ------------------------------------------------------------------------------
 */

#import <Foundation/Foundation.h>
#import "Reachability.h"
@import CoreTelephony;

/// Network Information
@interface Network: NSObject

/**
 Get Type Network
 
 - returns: Type Network
 */
- (nullable NSString *)type;

/**
 Get Service Set Identifier (SSID)
 
 - returns: Service Set Identifier string
 */
- (nullable NSString *)ssid;

/**
 Get Basic Service Set Identifier (BSSID)
 
 - returns: Basic Service Set Identifier string
 */
- (nullable NSString *)bssid;

/**
 Get Local IP Address
 
 - returns: Local IP Address
 */
- (nullable NSString *)localIPAddress;

/**
 Get Broadcast Address
 
 - returns: Broadcast Address
 */
- (nullable NSString *)broadcastAddress;

/**
 Get MAC Address
 
 - returns: MAC Address
 */
- (nullable NSString *)macAddress;

@end
