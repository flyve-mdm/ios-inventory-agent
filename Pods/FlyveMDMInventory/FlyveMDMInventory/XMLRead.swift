/*
 *   LICENSE
 *
 * XMLReader.swift is part of FlyveMDMInventory
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
 * @date      02/10/17
 * @copyright Copyright © 2017-2018 Teclib. All rights reserved.
 * @license   Apache License, Version 2.0 https://www.apache.org/licenses/LICENSE-2.0
 * @link      https://github.com/flyve-mdm/flyve-mdm-ios-inventory
 * @link      https://flyve-mdm.com
 * ------------------------------------------------------------------------------
 */

import Foundation

/// Enumerate XMLReaderOptions
public enum XMLReaderOptions: UInt {
    // Specifies whether the receiver reports the namespace and the qualified name of an element.
    case XMLReaderOptionsProcessNamespaces = 0
    // Specifies whether the receiver reports the scope of namespace declarations.
    case XMLReaderOptionsReportNamespacePrefixes
    // Specifies whether the receiver reports declarations of external entities.
    case XMLReaderOptionsResolveExternalEntities
}

// XMLReader class
public class XMLReader: NSObject {
    
    // MARK: Properties
    var arrayTemp: NSMutableArray!
    var dictionaryStack: NSMutableDictionary!
    var textInProgress: String!
    
    // MARK: Methods
    /// init method
    public override init() {
        super.init()
    }

    public static func dictionary(data: Data) throws -> NSDictionary {
        
        let reader = XMLReader()
        let rootDictionary: NSDictionary = (try reader.object(data: data, options: XMLReaderOptions(rawValue: 0)!))!
        return rootDictionary

    }
    
    public static func dictionary(_ XMLString: String) throws -> NSDictionary {
        
        let data = XMLString.data(using: .utf8)
        return try XMLReader.dictionary(data: data!)
    }

    func object(data: Data, options: XMLReaderOptions) throws -> NSDictionary? {
        
        // Clear out any old data
        self.arrayTemp = NSMutableArray()
        self.dictionaryStack = NSMutableDictionary()
        self.textInProgress = String()

        // Parse the XML
        let parser: XMLParser = XMLParser(data: data)
        parser.delegate = self
        let success: Bool = parser.parse()
        
        // Return the stack's root dictionary on success
        if success {
            let resultDict: NSDictionary = self.dictionaryStack
            return resultDict
        }
        
        return nil
    }
}

// MARK: XMLParserDelegate methods

extension XMLReader: XMLParserDelegate {
    
    public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        let tag = createTag(elementName)
        self.arrayTemp.insert(tag, at: arrayTemp.count)
        
        if self.dictionaryStack.count > 0 {
            let child = NSMutableDictionary()
            let childArray = NSMutableArray()

            if self.arrayTemp.count > 2 && self.arrayTemp[self.arrayTemp.count-2] as! String == "CONTENT".lowercased() {

                if (self.dictionaryStack.value(forKeyPath: self.arrayTemp.componentsJoined(by: ".")) != nil) {
                    
                    if let array: NSMutableArray = self.dictionaryStack.value(forKeyPath: self.arrayTemp.componentsJoined(by: ".")) as? NSMutableArray {
                        let arrayTempParent: NSMutableArray = array.mutableCopy() as! NSMutableArray
                        arrayTempParent.insert(NSMutableDictionary(), at: arrayTempParent.count)

                        self.dictionaryStack.setValue(arrayTempParent, forKeyPath: self.arrayTemp.componentsJoined(by: "."))
                    }
                    
                } else {
                    childArray.add(child)
                    self.dictionaryStack.setValue(childArray, forKeyPath: self.arrayTemp.componentsJoined(by: "."))
                }
            } else if self.arrayTemp.count > 3 {
                
            } else {
                child[tag] = NSMutableDictionary()
                self.dictionaryStack.setValue(child, forKeyPath: self.arrayTemp.componentsJoined(by: "."))
            }

        } else {
            self.dictionaryStack[tag] = NSMutableDictionary()
        }
    }
    
    public func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        let tag = createTag(elementName)
        if self.arrayTemp.count > 0 {
            let keyPath = self.arrayTemp.componentsJoined(by: ".")
            
            if !self.textInProgress.isEmpty {

                if self.arrayTemp.count > 2 {
                    
                    let keyPathParent = ((self.arrayTemp.subarray(with: NSMakeRange(0, 3)) as NSArray).mutableCopy() as AnyObject).componentsJoined(by: ".")

                    let dictionary = (self.dictionaryStack.value(forKeyPath: keyPathParent) as? NSMutableArray ?? NSMutableArray()).lastObject as? NSMutableDictionary ?? NSMutableDictionary()
                    dictionary.setValue(self.textInProgress, forKey: tag)

                } else {
                    self.dictionaryStack.setValue(self.textInProgress, forKeyPath: keyPath)
                }

            } else {
                let child: NSMutableDictionary = self.dictionaryStack.value(forKeyPath: keyPath) as? NSMutableDictionary ?? NSMutableDictionary()
                child.removeObject(forKey: tag)
            }

            self.arrayTemp.remove(tag)
            self.textInProgress = String()
        }
    }
    
    public func parser(_ parser: XMLParser, foundCharacters string: String) {
        self.textInProgress.append(string)
    }
    
    public func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        
    }
    
    func createTag(_ element: String) -> String {
        
        let arrElement = element.components(separatedBy: "_")
        if arrElement.count > 1 {
            var tag = String()
            
            for (index, value) in arrElement.enumerated() {
                
                if index == 0 {
                    tag = value.lowercased()
                } else {
                    tag += value.capitalized
                }
            }
            
            return tag
        } else {
            return element.lowercased()
        }
    }
}
