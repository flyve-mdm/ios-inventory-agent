/*
 *   Copyright © 2017 Teclib. All rights reserved.
 *
 * Cpu.h is part of FlyveMDMInventory
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

#import <Foundation/Foundation.h>

/// CPU Information
@interface Cpu: NSObject

/**
 Get branch string of cpus
 
 - returns: branch string of cpus
 */
- (nullable NSString *)branch;

/**
 Get vendor string of cpus
 
 - returns: vendor string of cpus
 */
- (nullable NSString *)vendor;

/**
 Get number of cpus
 
 - returns: number of cpus
 */
- (nullable NSString *)physicalCpu;

/**
 Get number of logical cpus
 
 - returns: number of logical cpus
 */
- (nullable NSString *)logicalCpu;

/**
 Get CPU frequency
 
 - returns: CPU frequency
 */
- (nullable NSString *)frequency;

/**
 Get bus frequency
 
 - returns: bus frequency
 */
- (nullable NSString *)busFrequency;

/**
 Get L1 I cache
 
 - returns: L1 I cache
 */
- (nullable NSString *)l1icache;

/**
 Get L1 D cache
 
 - returns: L1 D cache
 */
- (nullable NSString *)l1dcache;

/**
 Get L2 cache
 
 - returns: L2 cache
 */
- (nullable NSString *)l2cache;

@end
