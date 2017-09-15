/*
 *   Copyright © 2017 Teclib. All rights reserved.
 *
 * FlyveMDMInventoryAgentTests.swift is part of FlyveMDMInventoryAgent
 *
 * FlyveMDMInventoryAgent is a subproject of Flyve MDM. Flyve MDM is a mobile
 * device management software.
 *
 * FlyveMDMInventoryAgent is free software: you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 3
 * of the License, or (at your option) any later version.
 *
 * FlyveMDMInventoryAgent is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * ------------------------------------------------------------------------------
 * @author    Hector Rondon
 * @date      02/07/17
 * @copyright Copyright © 2017 Teclib. All rights reserved.
 * @license   GPLv3 https://www.gnu.org/licenses/gpl-3.0.html
 * @link      https://github.com/flyve-mdm/flyve-mdm-ios-inventory-agent.git
 * @link      https://flyve-mdm.com
 * ------------------------------------------------------------------------------
 */

import XCTest
import FlyveMDMInventory
import Alamofire

@testable import FlyveMDMInventoryAgent

class FlyveMDMInventoryAgentTests: XCTestCase {

    var window: UIWindow?
    let agentSettingsController = AgentSettingsController()

    override func setUp() {
        super.setUp()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        let navigationController = UINavigationController(rootViewController: agentSettingsController)
        window?.rootViewController = navigationController
    }

    /// This method is called after the invocation of each test method in the class.
    override func tearDown() {
        super.tearDown()
    }

    func testAgentSettingsController() {
        XCTAssertNotNil(window?.rootViewController, "The AgentSettingsControllerdid not start correctly")
    }

    /// Test if the inventory table is shown in view
    func testInventoryTableView() {
        XCTAssertNotNil(agentSettingsController.inventoryTableView, "inventoryTableView not shown in view")
    }

    /// Test if the footer is shown in view
    func testFooterView() {
        XCTAssertNotNil(agentSettingsController.footerView, "footerView not shown in view")
    }

    /// Test if the message label is shown in view
    func testMessageLabel() {
        XCTAssertNotNil(agentSettingsController.messageLabel, "messageLabel not shown in view")
    }

    /// Test if the loading indicator is shown in view
    func testLoadingIndicatorView() {
        XCTAssertNotNil(agentSettingsController.loadingIndicatorView, "loadingIndicatorView not shown in view")
    }

    func testCreateInventory() {
        let inventoryTask = InventoryTask()
        inventoryTask.execute("FusionInventory-Agent-iOS_v1.0", tag: "") { result in
            XCTAssertNotNil(result, "xml inventory was not created")
        }
    }

    func testSendXMLInventory() {
        let xml = "<?xml version='1.0' encoding='utf-8' standalone='yes' ?><REQUEST><QUERY>INVENTORY</QUERY><VERSIONCLIENT>FusionInventory-Agent-iOS_v1.0</VERSIONCLIENT><DEVICEID>83653177-D597-4558-AEDD-17D2971E91BC</DEVICEID><CONTENT><ACCESSLOG><LOGDATE>2017-06-27 14:10:31</LOGDATE><USERID>N/A</USERID></ACCESSLOG><BIOS><SMODEL>Darwin</SMODEL></BIOS><HARDWARE><NAME>Mac mini de Hector</NAME><TYPE>x86_64</TYPE><OSNAME>iOS</OSNAME><OSVERSION>10.3.1</OSVERSION><OSCOMMENTS>Version 10.3.1 (Build 14E8301)</OSCOMMENTS><ARCHNAME>x86_64</ARCHNAME><UUID>83653177-D597-4558-AEDD-17D2971E91BC</UUID><MEMORY>8192.0</MEMORY></HARDWARE><OPERATINGSYSTEM><KERNEL_NAME>Darwin</KERNEL_NAME><KERNEL_VERSION>16.6.0</KERNEL_VERSION><NAME>iOS</NAME><VERSION>10.3.1</VERSION><FULL_NAME>Darwin Kernel Version 16.6.0: Fri Apr 14 16:21:16 PDT 2017; root:xnu-3789.60.24~6/RELEASE_X86_64</FULL_NAME></OPERATINGSYSTEM><CPUS><CACHE>32768</CACHE><CORE>2</CORE><SPEED>not available</SPEED><ARCH>x86_64</ARCH></CPUS><DRIVES><LABEL>/dev/disk0s2</LABEL><VOLUMN>/</VOLUMN></DRIVES><DRIVES><LABEL>devfs</LABEL><VOLUMN>/dev</VOLUMN></DRIVES><DRIVES><LABEL>map -hosts</LABEL><VOLUMN>/net</VOLUMN></DRIVES><DRIVES><LABEL>map auto_home</LABEL><VOLUMN>/home</VOLUMN></DRIVES><MEMORIES><CAPACITY>8192.0</CAPACITY></MEMORIES><NETWORK><TYPE>WIFI</TYPE><MACADDR>A8:20:66:55:4A:B9</MACADDR><IPADDRESS>not available</IPADDRESS><IPSUBNET>not available</IPSUBNET><WIFI_SSID>not available</WIFI_SSID><WIFI_BSSID>not available</WIFI_BSSID></NETWORK><STORAGES><DISKSIZE>110.99 GB</DISKSIZE></STORAGES><VIDEOS><CHIPSET>OpenGL ES 2.0 APPLE-14.0.15</CHIPSET><NAME>Apple Inc.</NAME><RESOLUTION>1334x750</RESOLUTION></VIDEOS><SIMCARD><OPERATOR_NAME>not available</OPERATOR_NAME><COUNTRY_CODE>not available</COUNTRY_CODE><OPERATOR_CODE>not available</OPERATOR_CODE></SIMCARD><CAMERAS><RESOLUTION>0x0</RESOLUTION></CAMERAS><CAMERAS><RESOLUTION>0x0</RESOLUTION></CAMERAS></CONTENT></REQUEST>"

        let server = "https://dev.flyve.org/glpi/plugins/fusioninventory/front/communication.php"

        let headers: HTTPHeaders = [
            "User-Agent": "FusionInventory-Agent-iOS_v1.0",
            "Content-Type": "text/plain; charset=ISO-8859-1"
        ]

        Alamofire.request(server, method: .post, parameters: [:], encoding: xml, headers: headers)
            .validate(statusCode: 200..<300)
            .responseString { response in

                switch response.result {
                case .success:
                    break

                case .failure( _):
                    XCTFail("Expected get statusCode 200 to succeed, but it failed")
                    break
                }
        }
    }
}
