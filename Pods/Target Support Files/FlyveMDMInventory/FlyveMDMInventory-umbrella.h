#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "Battery.h"
#import "Carrier.h"
#import "Cpu.h"
#import "FlyveMDMInventory.h"
#import "Hardware.h"
#import "Memory.h"
#import "Network.h"
#import "OperatingSystem.h"
#import "Reachability.h"
#import "Storage.h"

FOUNDATION_EXPORT double FlyveMDMInventoryVersionNumber;
FOUNDATION_EXPORT const unsigned char FlyveMDMInventoryVersionString[];

