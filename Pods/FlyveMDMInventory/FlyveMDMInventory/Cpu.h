/*
 *   Copyright © 2017 Teclib. All rights reserved.
 *
 * Cpu.h is part of FlyveMDMInventory
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
 * @date      16/06/17
 * @copyright Copyright © 2017 Teclib. All rights reserved.
 * @license   GPLv3 https://www.gnu.org/licenses/gpl-3.0.html
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
