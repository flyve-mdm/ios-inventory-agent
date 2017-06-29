/*
 *   Copyright © 2017 Teclib. All rights reserved.
 *
 * Storage.m is part of FlyveMDMInventory
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

#import "Storage.h"

#include <sys/mount.h>

#define MB (1024*1024)
#define GB (MB*1024)


/// Disk space information
@implementation Storage : NSObject

/**
 Total disk space information
 
 - returns: Total disk space in the device
 */
- (NSString *)total {

    @try {
        
        long long space = [self longDiskSpace];
        
        // Check to make sure it's valid
        if (space <= 0) {
            // Error
            return nil;
        }

        NSString *diskSpace = [self formatMemory:space];
        
        // Check to make sure it's valid
        if (diskSpace == nil || diskSpace.length <= 0) {
            // Error
            return nil;
        }
        
        return diskSpace;
    }
    @catch (NSException * ex) {
        // Error
        return nil;
    }
}

/**
 Total Free disk space information
 
 - returns: Total Free disk space in the device
 */
- (NSString *)free:(BOOL)inPercent {

    @try {

        long long space = [self longFreeDiskSpace];
        
        // Check to make sure it's valid
        if (space <= 0) {
            // Error, no disk space found
            return nil;
        }
        
        NSString *diskSpace;
        
        // Output in percentage
        if (inPercent) {

            long long totalSpace = [self longDiskSpace];

            float percentDiskSpace = (space * 100) / totalSpace;
            // Check it to make sure it's okay
            if (percentDiskSpace <= 0) {
                // Error, invalid percent
                return nil;
            }

            diskSpace = [NSString stringWithFormat:@"%.f%%", percentDiskSpace];
        } else {
            diskSpace = [self formatMemory:space];
        }
        
        // Check to make sure it's valid
        if (diskSpace == nil || diskSpace.length <= 0) {
            // Error
            return nil;
        }
        
        return diskSpace;
    }
    @catch (NSException * ex) {
        // Error
        return nil;
    }
}

/**
 Total Used disk space information
 
 - returns: Total Used disk space in the device
 */
- (NSString *)used:(BOOL)inPercent {

    @try {

        long long UDS;
        long long TDS = [self longDiskSpace];
        long long FDS = [self longFreeDiskSpace];
        
        // Make sure they're valid
        if (TDS <= 0 || FDS <= 0) {
            // Error
            return nil;
        }

        UDS = TDS - FDS;
        
        // Make sure it's valid
        if (UDS <= 0) {
            // Error
            return nil;
        }

        NSString *usedDiskSpace;
        
        // Output in percentage
        if (inPercent) {
            
            float PercentUsedDiskSpace = (UDS * 100) / TDS;
            // Check it to make sure it's okay
            if (PercentUsedDiskSpace <= 0) {
                // Error
                return nil;
            }

            usedDiskSpace = [NSString stringWithFormat:@"%.f%%", PercentUsedDiskSpace];
        } else {
            // Turn that long long into a string
            usedDiskSpace = [self formatMemory:UDS];
        }
        
        // Check to make sure it's valid
        if (usedDiskSpace == nil || usedDiskSpace.length <= 0) {
            // Error
            return nil;
        }
        
        return usedDiskSpace;
        
    }
    @catch (NSException *exception) {
        // Error
        return nil;
    }
}

/**
 Get the total disk space in long format
 
 - returns: Total disk space in long format
 */
- (long long)longDiskSpace {

    @try {

        long long diskSpace = 0L;
        NSError *error = nil;
        NSDictionary *FileAttributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
        
        // Get the file attributes of the home directory
        if (error == nil) {
            // Get the size of the filesystem
            diskSpace = [[FileAttributes objectForKey:NSFileSystemSize] longLongValue];
        } else {
            // Error
            return -1;
        }
        
        // Check to make sure it's a valid size
        if (diskSpace <= 0) {
            // Invalid size
            return -1;
        }

        return diskSpace;
    }
    @catch (NSException *exception) {
        // Error
        return -1;
    }
}

/**
 Get the total free disk space in long format
 
 - returns: Total free disk space in long format
 */
- (long long)longFreeDiskSpace {
 
    @try {

        long long FreeDiskSpace = 0L;
        NSError *Error = nil;
        NSDictionary *FileAttributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&Error];
        
        // Get the file attributes of the home directory
        if (Error == nil) {
            FreeDiskSpace = [[FileAttributes objectForKey:NSFileSystemFreeSize] longLongValue];
        } else {
            // There was an error
            return -1;
        }
        
        // Check for valid size
        if (FreeDiskSpace <= 0) {
            // Invalid size
            return -1;
        }

        return FreeDiskSpace;
    }
    @catch (NSException *exception) {
        // Error
        return -1;
    }
}

/**
 Format the memory to a string in GB, MB, or Bytes
 
 - returns: Format the memory in string
 */
- (NSString *)formatMemory:(long long)space {

    @try {

        NSString *formattedBytes = nil;
        
        double numberBytes = 1.0 * space;
        double totalGB = numberBytes / GB;
        double totalMB = numberBytes / MB;
        

        if (totalGB >= 1.0) {
            formattedBytes = [NSString stringWithFormat:@"%.2f GB", totalGB];
        } else if (totalMB >= 1)
            formattedBytes = [NSString stringWithFormat:@"%.2f MB", totalMB];
        else {
            formattedBytes = [self memoryToString:space];
            formattedBytes = [formattedBytes stringByAppendingString:@" bytes"];
        }
        
        // Check for errors
        if (formattedBytes == nil || formattedBytes.length <= 0) {
            // Error
            return nil;
        }

        return formattedBytes;
    }
    @catch (NSException *exception) {
        // Error
        return nil;
    }
}

/**
 Formatted memory from bytes to a string
 
 - returns: Format the memory in string
 */
- (NSString *)memoryToString:(unsigned long long)space {
    @try {
        NSString *formattedBytes = nil;
        
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        
        [formatter setPositiveFormat:@"###,###,###,###"];
        
        NSNumber * theNumber = [NSNumber numberWithLongLong:space];
        
        formattedBytes = [formatter stringFromNumber:theNumber];
        
        // Check for errors
        if (formattedBytes == nil || formattedBytes.length <= 0) {
            // Error
            return nil;
        }
        
        return formattedBytes;
    }
    @catch (NSException *exception) {
        // Error
        return nil;
    }
}

/**
 Partitions disk information
 
 - returns: Partitions disk in the device
 */
- (NSString *)partitions {
    
    @try {
        
        NSMutableString *partitionsDisk = [[NSMutableString alloc] init];
        struct statfs *mntbufp;
        int num_of_mnts = 0;
        int i;
        
        num_of_mnts = getmntinfo(&mntbufp, MNT_WAIT);
        
        if(num_of_mnts == 0) {
            return nil;
        }
        
        for(i = 0; i < num_of_mnts; i++) {
            
            [partitionsDisk appendString:[NSString stringWithFormat:@"<DRIVES><LABEL>%s</LABEL><VOLUMN>%s</VOLUMN></DRIVES>", mntbufp[i].f_mntfromname, mntbufp[i].f_mntonname]];
        }
        
        return partitionsDisk;
        
    } @catch (NSException *exception) {
        // Error
        return nil;
    }
}

@end
