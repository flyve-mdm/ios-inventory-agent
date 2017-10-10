# Inventory Agent for iOS

![Flyve MDM banner](https://user-images.githubusercontent.com/663460/26935464-54267e9c-4c6c-11e7-86df-8cfa6658133e.png)

[![License](https://img.shields.io/github/license/flyve-mdm/flyve-mdm-ios-inventory-agent.svg?&label=License)](https://github.com/flyve-mdm/flyve-mdm-ios-inventory-agent/blob/master/LICENSE.md)
[![Follow twitter](https://img.shields.io/twitter/follow/FlyveMDM.svg?style=social&label=Twitter&style=flat-square)](https://twitter.com/FlyveMDM)
[![Telegram Group](https://img.shields.io/badge/Telegram-Group-blue.svg)](https://t.me/flyvemdm)
[![Conventional Commits](https://img.shields.io/badge/Conventional%20Commits-1.0.0-yellow.svg)](https://conventionalcommits.org)
[![GitHub release](https://img.shields.io/github/release/flyve-mdm/flyve-mdm-ios-inventory-agent.svg)](https://github.com/flyve-mdm/flyve-mdm-ios-inventory-agent/releases)
[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active)

Flyve MDM is a Mobile device management software that enables you to secure and manage all the mobile devices of your business or family via a web-based console.

To get started, check out <https://flyve-mdm.com/>!

## Table of contents

* [Synopsis](#synopsis)
* [Build Status](#build-status)
* [Installation](#installation)
* [Documentation](#documentation)
* [Versioning](#versioning)
* [Contribute](#contribute)
* [Contact](#contact)
* [Copying](#copying)

## Synopsis

This application is the iOS inventory agent of the Flyve MDM project.

It features a complete inventory of your iOS devices: both hardware and software informations are collected. You get the data about processor, memory, drives, sensors and [more](#data-collected).

Flyve MDM Inventory Agent for iOS can send inventory to:

* FusionInventory for GLPI 2.3.x and higher
* OCSInventory NG (ocsng) 1.3.x and 2.x
* Mandriva Pulse2

The Inventory project is a free software project providing:

* Hardware and software inventory (multiplatform)
* Network discovery
* Network inventory for printers and switches
* Wake On Lan (WOL)
* Software deployment
* Total integration with the GLPI project (open source asset management software and helpdesk)

Flyve MDM Inventory Agents can also be used with other open sources projects like Uranos or Rudder.

#### Data Collected

* Hardware
* Bios
* Operating System
* Memory
* Storages
* Drives
* CPUs
* Simcards
* Videos
* Cameras
* Networks
* Battery

Visit our [website](http://flyve.org/flyve-mdm-ios-inventory-agent/) for more information.

## Build Status

| **Release channel** | **Beta channel** |
|:---:|:---:|
| [![Build Status](https://circleci.com/gh/flyve-mdm/flyve-mdm-ios-inventory-agent/tree/master.svg?style=svg)](https://circleci.com/gh/flyve-mdm/flyve-mdm-inventory-agent/tree/master) | [![Build Status](https://circleci.com/gh/flyve-mdm/flyve-mdm-ios-inventory-agent/tree/develop.svg?style=svg)](https://circleci.com/gh/flyve-mdm/flyve-mdm-inventory-agent/tree/develop)

## Installation

Flyve MDM Inventory Agent for iOS is running on iOS 9.3 and higher.

Download the latest IPA, from GitHub releases, TestFlight or Apple Store.

[<img src="https://user-images.githubusercontent.com/663460/26986739-23bffc6e-4d49-11e7-92a2-cdba1b517a08.png" alt="Download from iTunes" height="60">](https://itunes.apple.com/us/app/flyve-mdm-inventory-agent)
[<img src="https://user-images.githubusercontent.com/663460/30159664-a0e818f4-93c9-11e7-9937-501201c36709.png" alt="Download IPA from GitHub" height="60">](https://github.com/flyve-mdm/flyve-mdm-ios-inventory-agent/releases/latest)

## Documentation

We maintain a detailed documentation of the project on its [website](http://flyve.org/flyve-mdm-ios-inventory-agent/).

## Versioning

In order to provide transparency on our release cycle and to maintain backward compatibility, Flyve MDM is maintained under [the Semantic Versioning guidelines](http://semver.org/). We are committed to following and complying with the rules, the best we can.

See [the tags section of our GitHub project](http://github.com/flyve-mdm/flyve-mdm-flyve-mdm.github.io/tags) for changelogs for each release version of Flyve MDM. Release announcement posts on [the official Teclib' blog](http://www.teclib-edition.com/en/communities/blog-posts/) contain summaries of the most noteworthy changes made in each release.

## Contribute

Want to file a bug, contribute some code, or improve documentation? Excellent! Read up on our
guidelines for [contributing](./CONTRIBUTING.md) and then check out one of our issues in the [Issues Dashboard](https://github.com/flyve-mdm/flyve-mdm-flyve-mdm.github.io/issues).

## Contact

For notices about major changes and general discussion of Flyve MDM development, subscribe to the [/r/FlyveMDM](http://www.reddit.com/r/FlyveMDM) subreddit.
You can also chat with us via IRC in [#flyve-mdm on freenode](http://webchat.freenode.net/?channels=flyve-mdm]).
Ping me @hectorerb in the IRC chatroom if you get stuck.

## Copying

* **Name**: [Flyve MDM](https://flyve-mdm.com/) is a registered trademark of [Teclib'](http://www.teclib-edition.com/en/).
* **Code**: you can redistribute it and/or modify
    it under the terms of the GNU General Public License ([GPLv3](https://www.gnu.org/licenses/gpl-3.0.en.html)).
* **Documentation**: released under Attribution 4.0 International ([CC BY 4.0](https://creativecommons.org/licenses/by/4.0/)).
