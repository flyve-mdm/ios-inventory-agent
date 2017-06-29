<img style="width:100%;" src="https://user-images.githubusercontent.com/663460/26935464-54267e9c-4c6c-11e7-86df-8cfa6658133e.png">

# [Flyve MDM](https://flyve-mdm.com)

Flyve MDM is a mobile device management software that enables you to secure and manage all the mobile devices of your business via a unique web-based console (MDM).

To get started, check out <https://flyve-mdm.com/>!



## Table of contents

* [Synopsis](#synopsis)
* [Build Status](#build-status)
* [Installation](#installation)
* [Code Example](#code-example)
* [Contributors](#contributors)
* [License](#license)

## Synopsis

This library help you to create a complete inventory of your iOS devices: both hardware and software informations are collected. You get the data about processor, memory, drives, sensors, etc. and also the list and description of installed application on any devices in a beautifull XML as protocol compatible with FusionInventory for GLPI.

You can find more information here:
<http://fusioninventory.org/documentation/dev/spec/protocol/inventory.html>

**What's included?**

* Hardware
* Bios
* Memory
* Inputs
* Sensors
* Drives
* Cpus
* Simcards
* Videos
* Cameras
* Networks
* Envs
* Jvm
* Softwares
* Usb
* Battery

## Build Status

Build with Xcode 8.3.2 / Swift 3.1

| **Release channel** | **Beta channel** |
|:---:|:---:|
| [![Build Status](https://travis-ci.org/flyve-mdm/flyve-mdm-ios-inventory.svg?branch=master)](https://travis-ci.org/flyve-mdm/flyve-mdm-ios-inventory) | [![Build Status](https://travis-ci.org/flyve-mdm/flyve-mdm-ios-inventory.svg?branch=develop)](https://travis-ci.org/flyve-mdm/flyve-mdm-ios-inventory) |

## Installation

### CocoaPods

Install using [CocoaPods](http://cocoapods.org) by adding this line to your Podfile:

````ruby
use_frameworks! # Add this if you are targeting iOS 8+ or using Swift
pod 'FlyveMDMInventory'  
````
Then, run the following command:

```bash
$ pod install
```

### Carthage

Install using [Carthage](https://github.com/Carthage/Carthage) by adding the following lines to your Cartfile:

````
github "flyve-mdm/flyve-mdm-ios-inventory" "master"
````
Then, run the following command:

```bash
$ carthage update --platform iOS
```

- On your application targets “General” settings tab, in the “Linked Frameworks and Libraries” section, drag and drop each framework you want to use from the Carthage/Build folder on disk.

- On your application targets “Build Phases” settings tab, click the “+” icon and choose “New Run Script Phase”. Create a Run Script with the following contents:
`/usr/local/bin/carthage copy-frameworks`

- and add the paths to the frameworks you want to use under “Input Files”, e.g.:
```
$(SRCROOT)/Carthage/Build/iOS/FlyveMDMInventory.framework

```

## Code Example

It's easy to implement in your code

```swift
import FlyveMDMInventory

FlyveMDMInventory.create("Agent_v1.0").responseXML { result in
    if let XML = result {
        print("XML: \(XML)")
    }
}

```

## Contributors

* [@hectorerb](https://github.com/hectorerb)
* [@ajsb85 ](https://github.com/ajsb85)

## License

The library is a Free Software under GPLv3 license.

![GPLv3](https://www.gnu.org/graphics/gplv3-88x31.png "GPLv3")
