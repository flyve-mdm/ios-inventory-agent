/*
 *   Copyright © 2017 Teclib. All rights reserved.
 *
 * Carrier.m is part of FlyveMDMInventory
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
 * @date      14/06/17
 * @copyright Copyright © 2017 Teclib. All rights reserved.
 * @license   Apache License, Version 2.0 https://www.apache.org/licenses/LICENSE-2.0
 * @link      https://github.com/flyve-mdm/flyve-mdm-ios-inventory
 * @link      https://flyve-mdm.com
 * ------------------------------------------------------------------------------
 */

#import "Carrier.h"

/// Carrier Information
@implementation Carrier

/**
 Get The current radio access technology is registered with
 
 - returns: Radio Access Technology
 */
- (NSString *)radio {
    
    @try {
        
        return [CTTelephonyNetworkInfo new].currentRadioAccessTechnology;
    }
    @catch (NSException *exception) {
        // Failed
        return nil;
    }
}

/**
 Get containing the name of the subscriber's cellular service provider
 
 - returns: Carrier Name
 */
- (NSString *)name {
    
    @try {
        
        return [[CTTelephonyNetworkInfo new] subscriberCellularProvider].carrierName;
    }
    @catch (NSException *exception) {
        // Failed
        return nil;
    }
}

/**
 Get containing the name of the carrier country code
 
 - returns: Carrier Country Code
 */
- (NSString *)countryCode {
    
    @try {
        
        return [[CTTelephonyNetworkInfo new] subscriberCellularProvider].isoCountryCode;
    }
    @catch (NSException *exception) {
        // Failed
        return nil;
    }
}

/**
 Get the  mobile network code for the subscriber's cellular service provider, in its numeric representation
 
 - returns: Mobile Network Code
 */
- (NSString *)mobileNetworkCode {
    
    @try {
        
        return [[CTTelephonyNetworkInfo new] subscriberCellularProvider].mobileNetworkCode;
    }
    @catch (NSException *exception) {
        // Failed
        return nil;
    }
}

/**
 Get if this carrier allows VOIP calls to be made on its network
 
 - returns: Carrier Allows VOIP
 */
- (NSString *)isAllowsVOIP {
    
    @try {
        
        if ([[CTTelephonyNetworkInfo new] subscriberCellularProvider].allowsVOIP) {
            return @"TRUE";
        } else {
            return @"FALSE";
        }
    }
    @catch (NSException *exception) {
        // Failed
        return @"FALSE";
    }
    
}


@end
