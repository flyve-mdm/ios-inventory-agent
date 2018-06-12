/*
 *   LICENSE
 *
 * OperatingSystem.m is part of FlyveMDMInventory
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
 * @date      15/06/17
 * @copyright Copyright © 2017-2018 Teclib. All rights reserved.
 * @license   Apache License, Version 2.0 https://www.apache.org/licenses/LICENSE-2.0
 * @link      https://github.com/flyve-mdm/flyve-mdm-ios-inventory
 * @link      https://flyve-mdm.com
 * ------------------------------------------------------------------------------
 */

#import "OperatingSystem.h"

#include <sys/sysctl.h>

@implementation OperatingSystem

/**
 Operating System Name
 
 - returns: Operating system name of Device string
 */
- (nullable NSString *)name {
    
    return [[UIDevice currentDevice] systemName];
}

/**
 Operating System Full Name
 
 - returns: Operating system full name of Device string
 */
- (nullable NSString *)fullName {
    
    return [self getSystemInfoWith:"kern.version"];
}

/**
 Operating System Version
 
 - returns: Operating system version of Device string
 */
- (nullable NSString *)version {
    
    NSOperatingSystemVersion version = [[NSProcessInfo processInfo] operatingSystemVersion];
    
    return [NSString stringWithFormat:@"%ld.%ld.%ld", (long)version.majorVersion, (long)version.minorVersion, (long)version.patchVersion];
}

/**
 Operating System Build
 
 - returns: Operating system build of Device string
 */
- (nullable NSString *)build {
    
    return [self getSystemInfoWith:"kern.osversion"];
}

/**
 Operating System Kernel Name
 
 - returns: Operating system kernel name of Device string
 */
- (nullable NSString *)kernelName {
    
    return [self getSystemInfoWith:"kern.ostype"];
}

/**
 Operating System Kernel Version
 
 - returns: Operating system kernel version of Device string
 */
- (nullable NSString *)kernelVersion {
    
    return [self getSystemInfoWith:"kern.osrelease"];
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

@end
