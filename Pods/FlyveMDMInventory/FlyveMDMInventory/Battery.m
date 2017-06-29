/*
 *   Copyright © 2017 Teclib. All rights reserved.
 *
 * Battery.m is part of FlyveMDMInventory
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

#import "Battery.h"

#include <UIKit/UIKit.h>

/// Battery Information
@implementation Battery

/**
 Get Battery State
 
 - returns: Battery State
 */
- (NSString *)state {
    
    [[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];
    
    NSInteger state = [[UIDevice currentDevice] batteryState];
    NSString *batteryState;
    
    switch (state) {
        case UIDeviceBatteryStateUnknown:
            batteryState = @"not available";
            break;
        case UIDeviceBatteryStateUnplugged:
            batteryState = @"Unplugged";
            break;
        case UIDeviceBatteryStateCharging:
            batteryState = @"Charging";
            break;
        case UIDeviceBatteryStateFull:
            batteryState = @"Fully charged";
            break;
        default:
            batteryState = @"not available";
            break;
    }
    
    return batteryState;
}

/**
 Get Battery Level
 
 - returns: Battery Level
 */
- (float)level {
    
    @try {
        
        [[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];
        
        float batteryLevel = [[UIDevice currentDevice] batteryLevel];
        
        if (batteryLevel > 0.0f) {
            batteryLevel = batteryLevel * 100;
        } else {
            return -1;
        }
        
        return batteryLevel;
    }
    @catch (NSException *exception) {
        // Error
        return -1;
    }
}

@end
