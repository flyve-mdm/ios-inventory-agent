/*
 *   Copyright © 2017 Teclib. All rights reserved.
 *
 * Cpu.m is part of FlyveMDMInventory
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
 * @date      16/06/17
 * @copyright Copyright © 2017 Teclib. All rights reserved.
 * @license   Apache License, Version 2.0 https://www.apache.org/licenses/LICENSE-2.0
 * @link      https://github.com/flyve-mdm/flyve-mdm-ios-inventory
 * @link      https://flyve-mdm.com
 * ------------------------------------------------------------------------------
 */

#import "Cpu.h"
#include <sys/sysctl.h>

/// CPU Information
@implementation Cpu

/**
 Get branch string of cpus
 
 - returns: branch string of cpus
 */
- (NSString *)branch {
    
    return [self getSystemInfoWith:"machdep.cpu.brand_string"];
}

/**
 Get vendor string of cpus
 
 - returns: vendor string of cpus
 */
- (NSString *)vendor {
    return [self getSystemInfoWith:"machdep.cpu.vendor"];
}

/**
 Get number of cpus
 
 - returns: number of cpus
 */
- (NSString *)physicalCpu {

    return [NSString stringWithFormat:@"%llu", [self getSystemInfoIntWith:"hw.physicalcpu"]];
}

/**
 Get number of logical cpus
 
 - returns: number of logical cpus
 */
- (NSString *)logicalCpu {
    
    return [NSString stringWithFormat:@"%llu", [self getSystemInfoIntWith:"hw.logicalcpu"]];
}

/**
 Get CPU frequency
 
 - returns: CPU frequency
 */
- (NSString *)frequency {
    
    int hertz;
    size_t size = sizeof(int);
    int mib[2] = {CTL_HW, HW_CPU_FREQ};
    
    sysctl(mib, 2, &hertz, &size, NULL, 0);
    
    if (hertz < 1) {
        // Invalid value
        return nil;
    }

    hertz /= 1000000;
    
    return [NSString stringWithFormat:@"%d", hertz];
}

/**
 Get bus frequency
 
 - returns: bus frequency
 */
- (NSString *)busFrequency {
    
    int hertz;
    size_t size = sizeof(int);
    int mib[2] = {CTL_HW, HW_BUS_FREQ};
    
    sysctl(mib, 2, &hertz, &size, NULL, 0);
    
    if (hertz < 1) {
        // Invalid value
        return nil;
    }
    
    hertz /= 1000000;
    
    return [NSString stringWithFormat:@"%d", hertz];
}

/**
 Get L1 I cache
 
 - returns: L1 I cache
 */
- (nullable NSString *)l1icache {
    
    return [NSString stringWithFormat:@"%llu", [self getSystemInfoIntWith:"hw.l1icachesize"]];
}

/**
 Get L1 D cache
 
 - returns: L1 D cache
 */
- (nullable NSString *)l1dcache {
    
    return [NSString stringWithFormat:@"%llu", [self getSystemInfoIntWith:"hw.l1dcachesize"]];
}

/**
 Get L2 cache
 
 - returns: L2 cache
 */
- (nullable NSString *)l2cache {
    
    return [NSString stringWithFormat:@"%llu", [self getSystemInfoIntWith:"hw.l2cachesize"]];
}

/**
 Information Hardware by name
 
 - returns: Information Hardware by name in string
 */
- (NSString *) getSystemInfoWith:(char *)name
{
    @try {
        size_t size = -1;
        sysctlbyname(name, NULL, &size, NULL, 0);
        
        char *value = malloc(size);
        sysctlbyname(name, value, &size, NULL, 0);
        
        NSString *result = [NSString stringWithCString:value encoding: NSUTF8StringEncoding];
        free(value);
        
        return result;
    } @catch (NSException *exception) {
        return nil;
    }
}

/**
 Information Hardware by name
 
 - returns: Information Hardware by name in string
 */
- (uint64_t) getSystemInfoIntWith:(char *)name
{
    @try {
        size_t size = -1;
        sysctlbyname(name, NULL, &size, NULL, 0);
        
        uint64_t value = 0;
        sysctlbyname(name, &value, &size, NULL, 0);
        
        return value;
    } @catch (NSException *exception) {
        return -1;
    }
    
    
}
@end
