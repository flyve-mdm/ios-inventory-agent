/*
 *   Copyright © 2017 Teclib. All rights reserved.
 *
 * FlyveMDMInventoryAgentUITests.swift is part of FlyveMDMInventoryAgent
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
 * @license   LGPLv3 https://www.gnu.org/licenses/lgpl-3.0.html
 * @link      https://github.com/flyve-mdm/flyve-mdm-ios-inventory-agent.git
 * @link      https://flyve-mdm.com
 * ------------------------------------------------------------------------------
 */

import XCTest

class FlyveMDMInventoryAgentUITests: XCTestCase {
    
    let app = XCUIApplication()

    /// This method is called before the invocation of each test method in the class.
    override func setUp() {
        super.setUp()

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.

        app.launchEnvironment = [ "UITest": "1" ]
        setupSnapshot(app)
        app.launch()
        sleep(1)
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    /// This method is called after the invocation of each test method in the class.
    override func tearDown() {
        super.tearDown()
    }
    
    /// This method take screenshots from fastlane snapshot
    func testTakeScreenshots() {
        
        let alert = app.alerts.element.collectionViews.buttons["OK"]
        if alert.exists {
            alert.tap()
        }
        snapshot("01Screen")
        let cells = app.tables.cells
        let inventoryCell = cells.element(boundBy: 2)
        inventoryCell.tap()
        snapshot("02Screen")
        app.navigationBars.buttons.element(boundBy: 0).tap()
        let globalCell = cells.element(boundBy: cells.count-2)
        globalCell.tap()
        snapshot("03Screen")
        app.navigationBars.buttons.element(boundBy: 0).tap()
        let aboutCell = cells.element(boundBy: cells.count-1)
        aboutCell.tap()
        snapshot("04Screen")
    }
}
