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
 * @author    Hector Rondon <hrondon@teclib.com>
 * @date      22/06/17
 * @copyright Copyright © 2017 Teclib. All rights reserved.
 * @license   LGPLv3 https://www.gnu.org/licenses/lgpl-3.0.html
 * @link      https://github.com/flyve-mdm/flyve-mdm-ios-inventory-agent.git
 * @link      https://flyve-mdm.com
 * ------------------------------------------------------------------------------
 */

import UIKit
import UserNotifications
import Bugsnag

public let serverAnonymous = "https://inventory.chollima.pro/-1001180163835/"
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
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound]) { (granted, _ ) in
                if !granted {
                    UserDefaults.standard.set(false, forKey: "notifications")
                } else {
                    UserDefaults.standard.set(true, forKey: "notifications")
                }
            }
        } else {
            
            UIApplication.shared.registerUserNotificationSettings(
                UIUserNotificationSettings(types: [.sound, .alert], categories: nil)
            )
        }

        // Set configuration Bugsnag
        let config = BugsnagConfiguration()
        config.apiKey = "9e545634de96524a1f39e2cd36e894a9"
        config.notifyURL = URL(string:"https://hooks.thestralbot.com/-1001061475099/")
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            config.appVersion = version
        }
        // Enable / Disable bugsnag
        config.autoNotify = !UserDefaults.standard.bool(forKey: "health_report")
        // Start Bugsnag with custom configuration
        Bugsnag.start(with: config)

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        // Change global tint color
        let flyveColor = UIColor.init(red: 23.0/255.0, green: 134.0/255.0, blue: 131.0/255.0, alpha: 1.0)
        window?.tintColor = flyveColor
        UISwitch.appearance().onTintColor = flyveColor
        
        let navigationController = UINavigationController(rootViewController: AgentSettingsController())
        window?.rootViewController = navigationController

        return true
    }
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        
        if let settings = UIApplication.shared.currentUserNotificationSettings {
            if settings.types.contains([.sound, .alert]) {
                //Have alert and sound permissions
                UserDefaults.standard.set(true, forKey: "notifications")
            } else {
                UserDefaults.standard.set(false, forKey: "notifications")
            }
        }
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
