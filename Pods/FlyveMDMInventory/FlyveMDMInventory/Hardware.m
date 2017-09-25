/*
 *   Copyright © 2017 Teclib. All rights reserved.
 *
 * Hardware.m is part of FlyveMDMInventory
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
 * @date      13/06/17
 * @copyright Copyright © 2017 Teclib. All rights reserved.
 * @license   GPLv3 https://www.gnu.org/licenses/gpl-3.0.html
 * @link      https://github.com/flyve-mdm/flyve-mdm-ios-inventory
 * @link      https://flyve-mdm.com
 * ------------------------------------------------------------------------------
 */

#import "Hardware.h"
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

#include <sys/sysctl.h>
#include <mach/machine.h>
#import <sys/utsname.h>

/// Hardware Information
@implementation Hardware

/**
 Device ID
 
 - returns: UUIDString
 */
- (NSString *)uuid {
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

/**
 Device Name
 
 - returns: Device name string
 */
- (nullable NSString *)name {
    
    return [[UIDevice currentDevice] name];
}

/**
 Model of Device
 
 - returns: Model of Device string
 */
- (nullable NSString *)model {
    
    return [self getSystemInfoWith:"hw.model"];
}

/**
 Identifier of Device
 
 - returns: Identifier of Device string
 */
- (nullable NSString *)identifier {
    
    struct utsname systemInfo;
    uname(&systemInfo);

    return [NSString stringWithCString:systemInfo.machine
                              encoding:NSUTF8StringEncoding];
}

/**
 Operating System Type
 
 - returns: Operating system type of Device string
 */
- (nullable NSString *)osType {
    
    struct utsname systemInfo;
    uname(&systemInfo);
    
    return [NSString stringWithCString:systemInfo.sysname
                              encoding:NSUTF8StringEncoding];
    
    
}

/**
 Operating System Version
 
 - returns: Operating system version of Device string
 */
- (nullable NSString *)osVersion {
    
    return [[NSProcessInfo processInfo] operatingSystemVersionString];
}

/**
 System architecture name
 
 - returns: System architecture name of Device string
 */
- (nullable NSString *)archName {
    
    NSMutableString *cpu = [[NSMutableString alloc] init];
    
    size_t size;
    cpu_type_t type;
    cpu_subtype_t subtype;
    
    size = sizeof(type);
    sysctlbyname("hw.cputype", &type, &size, NULL, 0);
    
    size = sizeof(subtype);
    sysctlbyname("hw.cpusubtype", &subtype, &size, NULL, 0);
    
    if (type == CPU_TYPE_X86)
    {
        [cpu appendString:@"x86"];
        
        if(sizeof(int*) == 8) {
            //system is 64-bit
            [cpu appendString:@"_64"];
        }
        
    }
    else if (type == CPU_TYPE_ARM)
    {
        [cpu appendString:@"ARM"];
        
        switch(subtype) {
            
            case CPU_SUBTYPE_ARM_V4T:
                [cpu appendString:@"_V4T"];
                break;
            case CPU_SUBTYPE_ARM_V6:
                [cpu appendString:@"_V6"];
                break;
            case CPU_SUBTYPE_ARM_V5TEJ:
                [cpu appendString:@"_V5TEJ"];
                break;
            case CPU_SUBTYPE_ARM_XSCALE:
                [cpu appendString:@"_XSCALE"];
                break;
            case CPU_SUBTYPE_ARM_V7:
                [cpu appendString:@"_V7"];
                break;
            case CPU_SUBTYPE_ARM_V7F:
                [cpu appendString:@"_V7F"];
                break;
            case CPU_SUBTYPE_ARM_V7S:
                [cpu appendString:@"_V7S"];
                break;
            case CPU_SUBTYPE_ARM_V7K:
                [cpu appendString:@"_V7K"];
                break;
            case CPU_SUBTYPE_ARM_V6M:
                [cpu appendString:@"_V6M"];
                break;
            case CPU_SUBTYPE_ARM_V7M:
                [cpu appendString:@"_V7M"];
                break;
            case CPU_SUBTYPE_ARM_V7EM:
                [cpu appendString:@"_V7EM"];
                break;
            case CPU_SUBTYPE_ARM_V8:
                [cpu appendString:@"_V8"];
                break;
      
        }
    } else if(type == CPU_TYPE_ARM64) {
        
        [cpu appendString:@"ARM64"];
        
        switch(subtype) {

            case CPU_SUBTYPE_ARM64_V8:
                [cpu appendString:@"_V8"];
                break;
        
        }
    }
    
    return [NSString stringWithString:cpu];
}

/**
 GPU Vendor name
 
 - returns: GPU Vendor of Device string
 */
- (nullable NSString *)gpuVendor {
    
    EAGLContext *ctx = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:ctx];
    
    return [NSString stringWithCString:(const char*)glGetString(GL_VENDOR) encoding:NSASCIIStringEncoding];
}

/**
 GPU Version name
 
 - returns: GPU Version of Device string
 */
- (nullable NSString *)gpuVersion {
    
    EAGLContext *ctx = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:ctx];
    
    return [NSString stringWithCString:(const char*)glGetString(GL_VERSION) encoding:NSASCIIStringEncoding];
}

/**
 Screen Resolution size
 
 - returns: Screen Resolution size of Device string
 */
- (nullable NSString *)screenResolution {
    
    CGRect dimension = [UIScreen mainScreen].bounds;
    CGFloat scale = [UIScreen mainScreen].scale;
    NSString *resolution = [NSString stringWithFormat:@"%0.0fx%0.0f", dimension.size.height * scale, dimension.size.width * scale];

    return resolution;
}

/**
 Front Camera Resolution size
 
 - returns: Front Camera Resolution size of Device string
 */
- (nullable NSString *)frontCamera {
    
    AVCaptureDevice *captureDevice = [self cameraWithPosition:AVCaptureDevicePositionFront];
    
    NSArray* availFormat=captureDevice.formats;
    AVCaptureDeviceFormat *format = [AVCaptureDeviceFormat alloc];
    format = availFormat[availFormat.count-1];

    return [NSString stringWithFormat:@"%dx%d", format.highResolutionStillImageDimensions.width, format.highResolutionStillImageDimensions.height];
}

/**
 Back Camera Resolution size
 
 - returns: Back Camera Resolution size of Device string
 */
- (nullable NSString *)backCamera {
    
    AVCaptureDevice *captureDevice = [self cameraWithPosition:AVCaptureDevicePositionBack];

    NSArray* availFormat=captureDevice.formats;
    AVCaptureDeviceFormat *format = [AVCaptureDeviceFormat alloc];
    format = availFormat[availFormat.count-1];
    
    return [NSString stringWithFormat:@"%dx%d", format.highResolutionStillImageDimensions.width, format.highResolutionStillImageDimensions.height];
}

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition) position {

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_10_2

    @try {
        NSArray *captureDeviceType = @[AVCaptureDeviceTypeBuiltInWideAngleCamera,
                                       AVCaptureDeviceTypeBuiltInTelephotoCamera,
                                       AVCaptureDeviceTypeBuiltInDualCamera];
        AVCaptureDeviceDiscoverySession *captureDevice = [AVCaptureDeviceDiscoverySession
                                                          discoverySessionWithDeviceTypes:captureDeviceType
                                                          mediaType:AVMediaTypeVideo
                                                          position:AVCaptureDevicePositionUnspecified];
        
        NSArray *devices = captureDevice.devices;
        
        for (AVCaptureDevice *device in devices) {
            if ([device position] == position) {
                return device;
            }
        }
    } @catch (NSException *exception) {
        // Error
        return nil;
    }

#else
    
    @try {
        NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
        for (AVCaptureDevice *device in devices) {
            if ([device position] == position) {
                return device;
            }
        }
    
    } @catch (NSException *exception) {
        // Error
        return nil;
    }

#endif

    return nil;
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
