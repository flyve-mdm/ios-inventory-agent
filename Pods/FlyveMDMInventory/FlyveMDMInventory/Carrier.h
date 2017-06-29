/*
 *   Copyright © 2017 Teclib. All rights reserved.
 *
 * Carrier.h is part of FlyveMDMInventory
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
 * @date      14/06/17
 * @copyright Copyright © 2017 Teclib. All rights reserved.
 * @license   GPLv3 https://www.gnu.org/licenses/gpl-3.0.html
 * @link      https://github.com/flyve-mdm/flyve-mdm-ios-inventory
 * @link      https://flyve-mdm.com
 * ------------------------------------------------------------------------------
 */

#import <Foundation/Foundation.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

/// Carrier Information
@interface Carrier: NSObject

/**
 Get The current radio access technology is registered with
 
 - returns: Radio Access Technology
 */
- (nullable NSString *)radio;

/**
 Get containing the name of the subscriber's cellular service provider
 
 - returns: Carrier Name
 */
- (nullable NSString *)name;

/**
 Get containing the name of the carrier country code
 
 - returns: Carrier Country Code
 */
- (nullable NSString *)countryCode;


// Carrier Mobile Network Code
/**
 Get the  mobile network code for the subscriber's cellular service provider, in its numeric representation
 
 - returns: Mobile Network Code
 */
- (nullable NSString *)mobileNetworkCode;

/**
 Get if this carrier allows VOIP calls to be made on its network
 
 - returns: Carrier Allows VOIP
 */
- (nullable NSString *)isAllowsVOIP;

@end
