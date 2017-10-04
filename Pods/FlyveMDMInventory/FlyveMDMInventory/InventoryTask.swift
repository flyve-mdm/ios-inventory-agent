/*
 *   Copyright © 2017 Teclib. All rights reserved.
 *
 * InventoryTask.swift is part of FlyveMDMInventory
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
 * @date      09/06/17
 * @copyright Copyright © 2017 Teclib. All rights reserved.
 * @license   Apache License, Version 2.0 https://www.apache.org/licenses/LICENSE-2.0
 * @link      https://github.com/flyve-mdm/flyve-mdm-ios-inventory
 * @link      https://flyve-mdm.com
 * ------------------------------------------------------------------------------
 */

import Foundation
import UIKit

public class InventoryTask {

    public let memory = Memory()
    public let storage = Storage()
    public let hardware = Hardware()
    public let os = OperatingSystem()
    public let battery = Battery()
    public let cpu = Cpu()
    public let network = Network()
    public let carrier = Carrier()
    
    public var isJson = false
    public init() {}

    /**
     Execute generate inventory
     
     - parameter versionClient: Cliente app identifier
     - returns: completion: (_ result: String) -> Void The XML String
     */
    public func execute(_ versionClient: String, tag: String = "", json: Bool = false, completion: (_ result: String) -> Void) {
        self.isJson = json
        completion(self.createXML(versionClient, tag: tag))
    }

    /**
     Creates an invetory
     
     - parameter versionClient: Cliente app identifier
     - returns: The XML String
     */
    private func createXML(_ versionClient: String, tag: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let dateLog = dateFormatter.string(from: Date())
        let xml = "\(createDTD())" +
            createElement(
                tag: "REQUEST",
                key: "REQUEST",
                value:
                createElement(tag: "QUERY", key: "QUERY", value: "INVENTORY") +
                    createElement(tag: "VERSIONCLIENT", key: "VERSION_CLIENT", value: versionClient) +
                    createElement(tag: "DEVICEID", key: "DEVICE_ID", value: "\(hardware.uuid() ?? "not available")") +
                    createElement(tag: "CONTENT", key: "CONTENT", value:
                        createElement(tag: "ACCESSLOG", key: "ACCESS_LOG", value:
                            createElement(tag: "LOGDATE", key: "LOG_DATE", value: "\(dateLog)") +
                                createElement(tag: "USERID", key: "USER_ID", value: "N/A")
                        ) +
                            createElement(tag: "ACCOUNTINFO", key: "ACCOUNT_INFO", value:
                                createElement(tag: "KEYNAME", key: "KEY_NAME", value: "TAG") +
                                    createElement(tag: "KEYVALUE", key: "KEY_VALUE", value: "\(tag != "" ? tag : "N/A" )")
                        ) +
                            createElement(tag: "BIOS", key: "BIOS", value:
                                createElement(tag: "BMANUFACTURER", key: "BMANUFACTURER", value: "\(hardware.gpuVendor() ?? "not available")") +
                                    createElement(tag: "MMODEL", key: "MMODEL", value: "\(hardware.identifier() ?? "not available")") +
                                    createElement(tag: "SMODEL", key: "SMODEL", value: "\(hardware.model() ?? "not available")")
                        ) +
                            createElement(tag: "HARDWARE", key: "HARDWARE", value:
                                createElement(tag: "NAME", key: "NAME", value: "\(hardware.model() ?? "not available")") +
                            createElement(tag: "TYPE", key: "TYPE", value: "\(hardware.identifier() ?? "not available")") +
                            createElement(tag: "OSNAME", key: "OS_NAME", value: "\(os.name() ?? "not available")") +
                            createElement(tag: "OSVERSION", key: "OS_VERSION", value: "\(os.version() ?? "not available")") +
                            createElement(tag: "OSCOMMENTS", key: "OS_COMMENTS", value: "\(hardware.osVersion() ?? "not available")") +
                                    createElement(tag: "ARCHNAME", key: "ARCH_NAME", value: "\(hardware.archName() ?? "not available")") +
                            createElement(tag: "UUID", key: "UUID", value: "\(hardware.uuid() ?? "not available")") +
                                    createElement(tag: "MEMORY", key: "MEMORY", value: "\(memory.total())")
                        ) +
                        createElement(tag: "OPERATINGSYSTEM", key: "OPERATING_SYSTEM", value:
                            createElement(tag: "KERNEL_NAME", key: "KERNEL_NAME", value: "\(os.kernelName() ?? "not available")") +
                            createElement(tag: "KERNEL_VERSION", key: "KERNEL_VERSION", value: "\(os.kernelVersion() ?? "not available")") +
                            createElement(tag: "NAME", key: "NAME", value: "\(os.name() ?? "not available")") +
                            createElement(tag: "VERSION", key: "VERSION", value: "\(os.version() ?? "not available")") +
                            createElement(tag: "FULL_NAME", key: "FULL_NAME", value: "\(os.fullName() ?? "not available")")
                        ) +
                        createElement(tag: "CPUS", key: "CPUS", value:
                            createElement(tag: "NAME", key: "NAME", value: "\(hardware.archName() ?? "not available")") +
                            createElement(tag: "MANUFACTURER", key: "MANUFACTURER", value: "\(hardware.gpuVendor() ?? "not available")") +
                            createElement(tag: "CACHE", key: "CACHE", value: "\(cpu.l1icache() ?? "not available")") +
                            createElement(tag: "CORE", key: "CORE", value: "\(cpu.physicalCpu() ?? "not available")") +
                            createElement(tag: "SPEED", key: "SPEED", value: "\(cpu.frequency() ?? "not available")") +
                            createElement(tag: "THREAD", key: "THREAD", value: "\(cpu.logicalCpu() ?? "not available")")
                        ) + "\(storage.partitions() ?? "")" +
                        createElement(tag: "MEMORIES", key: "MEMORIES", value:
                            createElement(tag: "CAPACITY", key: "CAPACITY", value: "\(memory.total())")
                        ) +
                        createElement(tag: "NETWORK", key: "NETWORK", value:
                            createElement(tag: "TYPE", key: "TYPE", value: "\(network.type() ?? "not available")") +
                            createElement(tag: "MACADDR", key: "MAC_ADDR", value: "\(network.macAddress() ?? "not available")") +
                            createElement(tag: "IPADDRESS", key: "IP_ADDRESS", value: "\(network.localIPAddress() ?? "not available")") +
                            createElement(tag: "IPSUBNET", key: "IP_SUBNET", value: "\(network.broadcastAddress() ?? "not available")") +
                            createElement(tag: "WIFI_SSID", key: "WIFI_SSID", value: "\(network.ssid() ?? "not available")") +
                            createElement(tag: "WIFI_BSSID", key: "WIFI_BSSID", value: "\(network.bssid() ?? "not available")")
                        ) +
                        createElement(tag: "STORAGES", key: "STORAGES", value:
                            createElement(tag: "DISKSIZE", key: "DISK_SIZE", value: "\(storage.total() ?? "not available")")
                        ) +
                        createElement(tag: "VIDEOS", key: "VIDEOS", value:
                            createElement(tag: "CHIPSET", key: "CHIPSET", value: "\(hardware.gpuVersion() ?? "not available")") +
                            createElement(tag: "NAME", key: "NAME", value: "\(hardware.gpuVendor() ?? "not available")") +
                            createElement(tag: "RESOLUTION", key: "RESOLUTION", value: "\(hardware.screenResolution() ?? "not available")")
                        ) +
                        createElement(tag: "SIMCARD", key: "SIM_CARD", value:
                            createElement(tag: "OPERATOR_NAME", key: "OPERATOR_NAME", value: "\(carrier.name() ?? "not available")") +
                            createElement(tag: "COUNTRY_CODE", key: "COUNTRY_CODE", value: "\(carrier.countryCode() ?? "not available")") +
                            createElement(tag: "OPERATOR_CODE", key: "OPERATOR_CODE", value: "\(carrier.mobileNetworkCode() ?? "not available")")
                        ) +
                        createElement(tag: "CAMERAS", key: "CAMERAS", value:
                            createElement(tag: "RESOLUTION", key: "RESOLUTION", value: "\(hardware.backCamera() ?? "not available")")
                        ) +
                        createElement(tag: "CAMERAS", key: "CAMERAS", value:
                            createElement(tag: "RESOLUTION", key: "RESOLUTION", value: "\(hardware.frontCamera() ?? "not available")")
                        )
                )
        )
        
        if self.isJson {
            do {
                let xmlDictionary = try XMLReader.dictionary(xml)
                let jsonData = try JSONSerialization.data(withJSONObject: xmlDictionary, options: .prettyPrinted)
                let jsonString = String(data: jsonData, encoding: .utf8)
                
                return jsonString ?? ""
                
            } catch {
                return error.localizedDescription
            }
        } else {
            return xml
        }
    }

    /**
     Creates the XML DTD
     
     - returns: the XML DTD String
     */
    private func createDTD() -> String {
        return "<?xml version='1.0' encoding='utf-8' standalone='yes' ?>"
    }

    /**
     Creates the XML Element
     
     - returns: the XML Element String
     */
    private func createElement(tag: String, key: String, value: String) -> String {
        if self.isJson {
            return "<\(key.uppercased())>\(value)</\(key.uppercased())>"
        } else {
            return "<\(tag.uppercased())>\(value)</\(tag.uppercased())>"
        }
    }
}
