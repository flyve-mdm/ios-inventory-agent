/*
 *   Copyright © 2017 Teclib. All rights reserved.
 *
 * Network.h is part of FlyveMDMInventory
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
