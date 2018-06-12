/*
 *   LICENSE
 *
 * Memory.m is part of FlyveMDMInventory
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
 * @date      07/06/17
 * @copyright Copyright © 2017-2018 Teclib. All rights reserved.
 * @license   Apache License, Version 2.0 https://www.apache.org/licenses/LICENSE-2.0
 * @link      https://github.com/flyve-mdm/flyve-mdm-ios-inventory
 * @link      https://flyve-mdm.com
 * ------------------------------------------------------------------------------
 */

#import "Memory.h"
#import <sys/stat.h>
#import <mach/mach.h>

@implementation Memory

/**
 Total Memory Information
 
 - returns: total ram memory in the device
 */
- (double)total {

	@try {

        double totalMemory = 0.00;
		
	    totalMemory = ([[NSProcessInfo processInfo] physicalMemory] / 1024.0) / 1024.0;
        
        // Round to the nearest multiple of 256mb
        int toNearest = 256;
        int remainder = (int)totalMemory % toNearest;
        
        if (remainder >= toNearest / 2) {
            totalMemory = ((int)totalMemory - remainder) + 256;
        } else {
            totalMemory = (int)totalMemory - remainder;
        }
        
        // Check to make sure it's valid
        if (totalMemory <= 0) {
            // Error
            return -1;
        }

        return totalMemory;
	}
	@catch (NSException *exception) {
        // Error
        return -1;
	}
}

/**
 Free Memory Information
 
 - returns: free ram memory in the device
 */
- (double)free {

    @try {

        double totalMemory = 0.00;
        vm_statistics_data_t vmStats;
        mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
        kern_return_t kernReturn = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmStats, &infoCount);
        
        if(kernReturn != KERN_SUCCESS) {
            return -1;
        }
        
        totalMemory = ((vm_page_size * vmStats.free_count) / 1024.0) / 1024.0;
        
        // Check to make sure it's valid
        if (totalMemory <= 0) {
            // Error
            return -1;
        }
        
        return totalMemory;
    }
    @catch (NSException *exception) {
        // Error
        return -1;
    }
}

/**
 Used Memory Information
 
 - returns: used ram memory in the device
 */
- (double)used {

    @try {

        double totalUsedMemory = 0.00;
        mach_port_t host_port;
        mach_msg_type_number_t host_size;
        vm_size_t pagesize;

        host_port = mach_host_self();
        host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
        host_page_size(host_port, &pagesize);
        
        vm_statistics_data_t vm_stat;
        
        // Check for any system errors
        if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS) {
            // Error, failed to get Virtual memory info
            return -1;
        }
        
        // Memory statistics in bytes
        natural_t UsedMemory = (natural_t)((vm_stat.active_count +
                                            vm_stat.inactive_count +
                                            vm_stat.wire_count) * pagesize);
        
        totalUsedMemory = (UsedMemory / 1024.0) / 1024.0;
        
        // Check to make sure it's valid
        if (totalUsedMemory <= 0) {
            // Error
            return -1;
        }
        
        return totalUsedMemory;
    }
    @catch (NSException *exception) {
        // Error
        return -1;
    }
}

/**
 Active Memory Information
 
 - returns: active ram memory in the device
 */
- (double)active {
 
    @try {
        double totalMemory = 0.00;
        mach_port_t host_port;
        mach_msg_type_number_t host_size;
        vm_size_t pagesize;

        host_port = mach_host_self();
        host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
        host_page_size(host_port, &pagesize);
        
        vm_statistics_data_t vm_stat;
        
        // Check for any system errors
        if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS) {
            // Error, failed to get Virtual memory info
            return -1;
        }

        totalMemory = ((vm_stat.active_count * pagesize) / 1024.0) / 1024.0;
        
        // Check to make sure it's valid
        if (totalMemory <= 0) {
            // Error, invalid memory value
            return -1;
        }

        return totalMemory;
    }
    @catch (NSException *exception) {
        // Error
        return -1;
    }
}

/**
 Inactive Memory Information
 
 - returns: inactive ram memory in the device
 */
- (double)inactive {
    
    @try {
        
        double totalMemory = 0.00;
        mach_port_t host_port;
        mach_msg_type_number_t host_size;
        vm_size_t pagesize;
        
        host_port = mach_host_self();
        host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
        host_page_size(host_port, &pagesize);
        
        vm_statistics_data_t vm_stat;
        
        // Check for any system errors
        if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS) {
            // Error, failed to get Virtual memory info
            return -1;
        }
        
        totalMemory = ((vm_stat.inactive_count * pagesize) / 1024.0) / 1024.0;
        
        // Check to make sure it's valid
        if (totalMemory <= 0) {
            // Error, invalid memory value
            return -1;
        }
        
        return totalMemory;
    }
    @catch (NSException *exception) {
        // Error
        return -1;
    }
}

@end
