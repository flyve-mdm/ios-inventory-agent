/*
 *   Copyright © 2017 Teclib. All rights reserved.
 *
 * AppDelegate.swift is part of FlyveMDMInventoryAgent
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
 * @date      22/06/17
 * @copyright Copyright © 2017 Teclib. All rights reserved.
 * @license   GPLv3 https://www.gnu.org/licenses/gpl-3.0.html
 * @link      https://github.com/flyve-mdm/flyve-mdm-ios-inventory-agent.git
 * @link      https://flyve-mdm.com
 * ------------------------------------------------------------------------------
 */

import UIKit
import  UserNotifications

/// class starting point of the application
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: Properties

    /// This property contains the window used to present the app’s visual content on the device’s main screen.
    var window: UIWindow?

    // MARK: Methods

    /// Starting point of the application
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        //Requesting Authorization for User Interactions
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (_, _) in
            // Enable or disable features based on authorization.
        }

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        let navigationController = UINavigationController(rootViewController: AgentSettingsController())
        window?.rootViewController = navigationController

        return true
    }

    /// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    /// Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    func applicationWillResignActive(_ application: UIApplication) { }

    /// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    /// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    func applicationDidEnterBackground(_ application: UIApplication) { }

    /// Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    func applicationWillEnterForeground(_ application: UIApplication) { }

    /// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    func applicationDidBecomeActive(_ application: UIApplication) { }

    /// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    func applicationWillTerminate(_ application: UIApplication) { }
}
