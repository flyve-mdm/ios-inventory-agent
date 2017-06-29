/*
 *   Copyright © 2017 Teclib. All rights reserved.
 *
 * Localizator.swift is part of FlyveMDMInventoryAgent
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
 * @date      28/06/17
 * @copyright Copyright © 2017 Teclib. All rights reserved.
 * @license   GPLv3 https://www.gnu.org/licenses/gpl-3.0.html
 * @link      https://github.com/flyve-mdm/fusioninventory-ios
 * @link      https://flyve-mdm.com
 * ------------------------------------------------------------------------------
 */

import Foundation

private class Localizator {
    
    static let sharedInstance = Localizator()
    
    lazy var localizableDictionary: NSDictionary! = {
        if let path = Bundle.main.path(forResource: "Localizable", ofType: "plist") {
            return NSDictionary(contentsOfFile: path)
        }
        fatalError("Localizable file NOT found")
    }()
    
    func localize(string: String) -> String {
        
        guard let localizedString = localizableDictionary.value(forKey: string) as? String else {

            return string
        }
        return localizedString
    }
}

extension String {
    var localized: String {
        return Localizator.sharedInstance.localize(string: self)
    }
}
