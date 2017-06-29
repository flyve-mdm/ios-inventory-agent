/*
 *   Copyright © 2017 Teclib. All rights reserved.
 *
 * Memory.m is part of FlyveMDMInventory
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
 * @date      07/06/17
 * @copyright Copyright © 2017 Teclib. All rights reserved.
 * @license   GPLv3 https://www.gnu.org/licenses/gpl-3.0.html
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
