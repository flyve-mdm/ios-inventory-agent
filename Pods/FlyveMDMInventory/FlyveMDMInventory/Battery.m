/*
 *   LICENSE
 *
 * Battery.m is part of FlyveMDMInventory
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
 * @date      14/06/17
 * @copyright Copyright © 2017-2018 Teclib. All rights reserved.
 * @license   Apache License, Version 2.0 https://www.apache.org/licenses/LICENSE-2.0
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
