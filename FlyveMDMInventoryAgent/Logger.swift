/*
 *   Copyright © 2017 Teclib. All rights reserved.
 *
 * Logger.swift is part of flyve-mdm-ios
 *
 * flyve-mdm-ios is a subproject of Flyve MDM. Flyve MDM is a mobile
 * device management software.
 *
 * flyve-mdm-ios is free software: you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 3
 * of the License, or (at your option) any later version.
 *
 * flyve-mdm-ios is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * ------------------------------------------------------------------------------
 * @author    Hector Rondon
 * @date      16/08/17
 * @copyright Copyright © 2017 Teclib. All rights reserved.
 * @license   LGPLv3 https://www.gnu.org/licenses/lgpl-3.0.html
 * @link      https://github.com/flyve-mdm/flyve-mdm-ios-agent
 * @link      https://flyve-mdm.com
 * ------------------------------------------------------------------------------
 */

import Foundation

/// Enum for showing the type of Log Types
enum LogEvent {

    case trace, debug, info, warning, error
    
    var description: String {
        return String(describing: self).uppercased()
    }
}

/// Logger class
class Logger {
    // MARK: Properties
    /// date format
    static var dateFormat = "yyyy-MM-dd hh:mm:ssSSS"
    /// date formatter
    static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        return formatter
    }
    
    // MARK: Methods
    /**
     Logs a message with a trace severity level.
     
     - parameter message: The message to log
     - parameter type: The the type of Log Types
     - parameter file: The file in which the log happens
     - parameter line: The line at which the log happens
     - parameter column: The column at which the log happens
     - parameter function: The function in which the log happens
     */
    class func log(message: String,
                   type: LogEvent,
                   fileName: String = #file,
                   line: Int = #line,
                   column: Int = #column,
                   funcName: String = #function) {
        
        Logger.saveLogEvent("\(Date().toString()) \(type.description): \(sourceFileName(fileName)) \(funcName) line: \(line) column: \(column) -> \(message)\n", type: type)
    }
    
    /**
     Get file name source
     
     - parameter filePath: The file path source
     */
    private class func sourceFileName(_ filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        return components.isEmpty ? "" : components.last!
    }
    
    /**
     Save logger event
     
     - parameter log: log entry
     - parameter type: The the type of Log Types
     */
    private class func saveLogEvent(_ log: String, type: LogEvent) {
        
        var file = String()
        
        if type == .error {
            file = "errors.log"
        } else {
            file = "events.log"
        }
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let path = dir.appendingPathComponent(file)
            
            if FileManager.default.fileExists(atPath: path.path) {
                if let fileHandle = try? FileHandle(forUpdating: path) {
                    fileHandle.seekToEndOfFile()
                    fileHandle.write(log.data(using: String.Encoding.utf8)!)
                    fileHandle.closeFile()
                    
                }
            } else {
                //writing
                do {
                    try log.write(to: path, atomically: false, encoding: String.Encoding.utf8)
                } catch {/* error handling here */}
            }
        }
    }
}

internal extension Date {
    /**
     Get date formatter to string
     
     - return: date formatter to string
     */

    func toString() -> String {
        return Logger.dateFormatter.string(from: self as Date)
    }
}
