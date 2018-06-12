/*
 *   LICENSE
 *
 * GlobalSettingsController.swift is part of FlyveMDMInventoryAgent
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
 * @date      27/06/17
 * @copyright Copyright © 2017-2018 Teclib. All rights reserved.
 * @license   LGPLv3 https://www.gnu.org/licenses/lgpl-3.0.html
 * @link      https://github.com/flyve-mdm/ios-inventory-agent.git
 * @link      https://flyve-mdm.com
 * ------------------------------------------------------------------------------
 */

import UIKit
import UserNotifications
import Bugsnag

/// GlobalSettingsController class
class GlobalSettingsController: UIViewController {
    
    // MARK: Properties
    
    let cellId = "InventoryCell"

    /// This property contains the configurations for the table view
    lazy var settingsTableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.delegate = self
        table.dataSource = self
        table.translatesAutoresizingMaskIntoConstraints = false
        table.tableFooterView = UIView()
        table.backgroundColor = UIColor.init(red: 239.0/255.0, green: 239.0/255.0, blue: 244.0/255.0, alpha: 1.0)
        table.rowHeight = UITableViewAutomaticDimension
        table.estimatedRowHeight = 100
        table.register(UITableViewCell.self, forCellReuseIdentifier: self.cellId)
        return table
    }()

    /// This property contains the configurations for the footer view
    let footerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()

    /// This property contains the configurations of the loading indicator view
    let loadingIndicatorView: UIActivityIndicatorView = {
        let loading = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        loading.color = .gray
        loading.translatesAutoresizingMaskIntoConstraints = false
        loading.hidesWhenStopped = true
        return loading
    }()

    // MARK: Methods
    
    /// Load the customized view that the controller manages
    override func loadView() {
        super.loadView()
        
        checkNotificationEnabled()
        setupViews()
        addConstraints()
        
        // set observer for UIApplicationWillEnterForeground
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: .UIApplicationWillEnterForeground, object: nil)
    }
    
    /// Set up the views of the controller
    func setupViews() {
        view.backgroundColor = .white
        navigationItem.titleView = UIImageView(image: UIImage(named: "logo"))
        view.addSubview(settingsTableView)
    }
    
    /// Add the constraints to the views of the controller
    func addConstraints() {
        settingsTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        settingsTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        settingsTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        settingsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    /// this method is called when app enter to foreground
    @objc func willEnterForeground() {
        checkNotificationEnabled()
        settingsTableView.reloadData()
    }
    
    /// check state of notifications
    func checkNotificationEnabled() {
        
        if #available(iOS 10.0, *) {
            
            UNUserNotificationCenter.current().getNotificationSettings { (settings) in
                if settings.authorizationStatus == .authorized {
                    // Notifications allowed
                    UserDefaults.standard.set(true, forKey: "notifications")
                } else {
                    UserDefaults.standard.set(false, forKey: "notifications")
                }
            }
            
        } else {
            if let settings = UIApplication.shared.currentUserNotificationSettings {
                if settings.types.contains([.sound, .alert]) {
                    //Have alert and sound permissions
                    UserDefaults.standard.set(true, forKey: "notifications")
                } else {
                    UserDefaults.standard.set(false, forKey: "notifications")
                }
            }
        }
    }
    
    /// show system settings
    func openSettings() {
        
        DispatchQueue.main.async {
            var message = String()
            
            if UserDefaults.standard.bool(forKey: "notifications") {
                message = NSLocalizedString("alert_disable_notifications", comment: "")
            } else {
                message = NSLocalizedString("alert_enable_notifications", comment: "")
            }
            
            let alertController = UIAlertController (title: NSLocalizedString("notifications", comment: ""), message: message, preferredStyle: .alert)
            
            let settingsAction = UIAlertAction(title: NSLocalizedString("open_settings", comment: ""), style: .default) { (_) -> Void in
                guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                    return
                }
                
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (_ ) in
                        })
                    } else {
                        UIApplication.shared.openURL(settingsUrl)
                    }
                }
            }
            alertController.addAction(settingsAction)
            let cancelAction = UIAlertAction(title: NSLocalizedString("later", comment: ""), style: .default, handler: { (_) -> Void in
                self.settingsTableView.reloadData()
            })
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    /**
     Enable or Disable notifications
     */
    @objc func switchAtValueChanged(uiSwitch: UISwitch) {
        if uiSwitch.tag == 777 {
            openSettings()
        } else if uiSwitch.tag == 888 {
            let index: IndexPath = IndexPath(row: 0, section: 3)
            UserDefaults.standard.set(!UserDefaults.standard.bool(forKey: "health_report"), forKey: "health_report")
            // enable / disable bugsnag
            Bugsnag.configuration()?.autoNotify = !UserDefaults.standard.bool(forKey: "health_report")
            settingsTableView.beginUpdates()
            settingsTableView.reloadRows(at: [index], with: .automatic)
            settingsTableView.endUpdates()
        } else if uiSwitch.tag == 999 {
            let index: IndexPath = IndexPath(row: 1, section: 3)
            UserDefaults.standard.set(!UserDefaults.standard.bool(forKey: "usage_data"), forKey: "usage_data")
            //disable usage data
            settingsTableView.beginUpdates()
            settingsTableView.reloadRows(at: [index], with: .automatic)
            settingsTableView.endUpdates()
        }
    }
}

// MARK: UITableViewDataSource
extension GlobalSettingsController: UITableViewDataSource {

    /**
     override `numberOfSections` from super class, get number of sections
     
     - return: number of sections
     */
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    /**
     override `numberOfRowsInSection` from super class, get number of row in sections
     
     - return: number of row in sections
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 2
        }
    }

    /**
     override `cellForRowAt` from super class, Asks the data source for a cell to insert in a particular location of the table view
     
     - return: `UITableViewCell`
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: cellId)
        cell.selectionStyle = UITableViewCellSelectionStyle.none

        if indexPath.section == 0 && indexPath.row == 0 {
            let notificationSwitch = UISwitch()
            notificationSwitch.translatesAutoresizingMaskIntoConstraints = false
            notificationSwitch.tag = 777
            notificationSwitch.addTarget(self, action: #selector(self.switchAtValueChanged(uiSwitch:)), for: UIControlEvents.valueChanged)
            cell.textLabel?.text = NSLocalizedString("notifications", comment: "")
            
            if UserDefaults.standard.bool(forKey: "notifications") {
                cell.detailTextLabel?.text = NSLocalizedString("notifications_disable", comment: "")
            } else {
                cell.detailTextLabel?.text = NSLocalizedString("notifications_enable", comment: "")
            }

            cell.contentView.addSubview(notificationSwitch)
            notificationSwitch.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor).isActive = true
            notificationSwitch.rightAnchor.constraint(equalTo: cell.contentView.rightAnchor, constant: -16.0).isActive = true
            notificationSwitch.setOn(UserDefaults.standard.bool(forKey: "notifications"), animated: false)

        } else if indexPath.section == 1 && indexPath.row == 0 {
            cell.textLabel?.text = NSLocalizedString("server", comment: "")

            if UserDefaults.standard.string(forKey: "nameServer") != "" && UserDefaults.standard.string(forKey: "nameServer") != nil {
                cell.detailTextLabel?.text = UserDefaults.standard.string(forKey: "nameServer") ?? NSLocalizedString("server_input", comment: "")
            } else {
                cell.detailTextLabel?.text = NSLocalizedString("server_input", comment: "")
            }

        } else if indexPath.section == 1 && indexPath.row == 1 {
            cell.textLabel?.text = NSLocalizedString("tag", comment: "")

            if UserDefaults.standard.string(forKey: "nameTag") != "" && UserDefaults.standard.string(forKey: "nameTag") != nil {
                cell.detailTextLabel?.text = UserDefaults.standard.string(forKey: "nameTag") ?? ""
            } else {
                cell.detailTextLabel?.text = NSLocalizedString("tag_input", comment: "")
            }

        } else if indexPath.section == 2 && indexPath.row == 0 {
            cell.textLabel?.text = NSLocalizedString("login", comment: "")

            if UserDefaults.standard.string(forKey: "login") != "" {
                cell.detailTextLabel?.text = UserDefaults.standard.string(forKey: "login") ?? ""
            } else {
                cell.detailTextLabel?.text = ""
            }

        } else if indexPath.section == 2 && indexPath.row == 1 {
            cell.textLabel?.text = NSLocalizedString("password", comment: "")

            if UserDefaults.standard.string(forKey: "password") != "" {
                cell.detailTextLabel?.text = UserDefaults.standard.string(forKey: "password") ?? ""
            } else {
                cell.detailTextLabel?.text = ""
            }
        } else if indexPath.section == 3 && indexPath.row == 0 {
            let crashSwitch = UISwitch()
            crashSwitch.translatesAutoresizingMaskIntoConstraints = false
            crashSwitch.tag = 888
            crashSwitch.addTarget(self, action: #selector(self.switchAtValueChanged(uiSwitch:)), for: UIControlEvents.valueChanged)
            cell.textLabel?.text = NSLocalizedString("health_report", comment: "")
            
            if UserDefaults.standard.bool(forKey: "health_report") {
                cell.detailTextLabel?.text = NSLocalizedString("health_report_enable", comment: "")
            } else {
                cell.detailTextLabel?.text = NSLocalizedString("health_report_disable", comment: "")
            }

            cell.contentView.addSubview(crashSwitch)
            crashSwitch.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor).isActive = true
            crashSwitch.rightAnchor.constraint(equalTo: cell.contentView.rightAnchor, constant: -16.0).isActive = true
            crashSwitch.setOn(!UserDefaults.standard.bool(forKey: "health_report"), animated: false)
            
        } else if indexPath.section == 3 && indexPath.row == 1 {
            let dataSwitch = UISwitch()
            dataSwitch.translatesAutoresizingMaskIntoConstraints = false
            dataSwitch.tag = 999
            dataSwitch.addTarget(self, action: #selector(self.switchAtValueChanged(uiSwitch:)), for: UIControlEvents.valueChanged)
            cell.textLabel?.text = NSLocalizedString("usage_data", comment: "")

            if UserDefaults.standard.bool(forKey: "usage_data") {
                cell.detailTextLabel?.text = NSLocalizedString("usage_data_enable", comment: "")
            } else {
                cell.detailTextLabel?.text = NSLocalizedString("usage_data_disable", comment: "")
            }

            cell.contentView.addSubview(dataSwitch)
            dataSwitch.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor).isActive = true
            dataSwitch.rightAnchor.constraint(equalTo: cell.contentView.rightAnchor, constant: -16.0).isActive = true
            dataSwitch.setOn(!UserDefaults.standard.bool(forKey: "usage_data"), animated: false)
        }
        return cell
    }

    /**
     override `cellForRowAt` from super class, Asks the data source for a cell to insert in a particular location of the table view
     
     - return: `UITableViewCell`
     */
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return NSLocalizedString("global_title", comment: "")
        } else if section == 1 {
            return NSLocalizedString("server", comment: "")
        } else if section == 2 {
            return NSLocalizedString("authentication_credentials", comment: "")
        } else {
            return NSLocalizedString("privacy", comment: "")
        }
    }
}

// MARK: UITableViewDelegate
extension GlobalSettingsController: UITableViewDelegate {

    /**
     override `willDisplayHeaderView` from super class
     */
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {

        if let headerView = view as? UITableViewHeaderFooterView, let textLabel = headerView.textLabel {
            headerView.backgroundView?.backgroundColor = UIColor.init(red: 239.0/255.0, green: 239.0/255.0, blue: 244.0/255.0, alpha: 1.0)
            textLabel.font = UIFont.systemFont(ofSize: 12.0, weight: UIFont.Weight.bold)
            textLabel.textColor = UIColor.gray
        }
    }

    /**
     override `didSelectRowAt` from super class, tells the delegate that the specified row is now selected
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            openSettings()

        } else if indexPath.section == 1 && indexPath.row == 0 {
            //Server address
            DispatchQueue.main.async {
                let alert = UIAlertController(title: NSLocalizedString("server", comment: ""), message: NSLocalizedString("server_input", comment: ""), preferredStyle: UIAlertControllerStyle.alert)

                alert.addAction(UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: UIAlertActionStyle.default, handler: nil))
                alert.addAction(UIAlertAction(title: NSLocalizedString("accept", comment: ""), style: UIAlertActionStyle.default, handler: { _ in

                    UserDefaults.standard.set(alert.textFields?[0].text ?? "", forKey: "nameServer")
                    tableView.beginUpdates()
                    tableView.reloadRows(at: [indexPath], with: .automatic)
                    tableView.endUpdates()
                }
                ))
                alert.addTextField(configurationHandler: {(textField: UITextField!) in
                    textField.placeholder = ""
                    textField.text = UserDefaults.standard.string(forKey: "nameServer") ?? ""
                    textField.isSecureTextEntry = false // for password input
                })
                self.present(alert, animated: true, completion: nil)
            }
        } else if indexPath.section == 1 && indexPath.row == 1 {

            //Tag
            DispatchQueue.main.async {
                let alert = UIAlertController(title: NSLocalizedString("tag", comment: ""), message: NSLocalizedString("tag_input", comment: ""), preferredStyle: UIAlertControllerStyle.alert)

                alert.addAction(UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: UIAlertActionStyle.default, handler: nil))
                alert.addAction(UIAlertAction(title: NSLocalizedString("accept", comment: ""), style: UIAlertActionStyle.default, handler: { _ in

                    UserDefaults.standard.set(alert.textFields?[0].text ?? "", forKey: "nameTag")
                    tableView.beginUpdates()
                    tableView.reloadRows(at: [indexPath], with: .automatic)
                    tableView.endUpdates()
                }
                ))
                alert.addTextField(configurationHandler: {(textField: UITextField!) in
                    textField.placeholder = ""
                    textField.text = UserDefaults.standard.string(forKey: "nameTag") ?? ""
                    textField.isSecureTextEntry = false // for password input
                })
                self.present(alert, animated: true, completion: nil)
            }

        } else if indexPath.section == 2 && indexPath.row == 0 {
            //login
            DispatchQueue.main.async {
                let alert = UIAlertController(title: NSLocalizedString("login", comment: ""), message: NSLocalizedString("login_input", comment: ""), preferredStyle: UIAlertControllerStyle.alert)

                alert.addAction(UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: UIAlertActionStyle.default, handler: nil))
                alert.addAction(UIAlertAction(title: NSLocalizedString("accept", comment: ""), style: UIAlertActionStyle.default, handler: { _ in

                    UserDefaults.standard.set(alert.textFields?[0].text ?? "", forKey: "login")
                    tableView.beginUpdates()
                    tableView.reloadRows(at: [indexPath], with: .automatic)
                    tableView.endUpdates()
                }
                ))
                alert.addTextField(configurationHandler: {(textField: UITextField!) in
                    textField.placeholder = ""
                    textField.text = UserDefaults.standard.string(forKey: "login") ?? ""
                    textField.isSecureTextEntry = false // for password input
                })
                self.present(alert, animated: true, completion: nil)
            }

        } else if indexPath.section == 2 && indexPath.row == 1 {
            //password
            DispatchQueue.main.async {
                let alert = UIAlertController(title: NSLocalizedString("password", comment: ""), message: NSLocalizedString("password_input", comment: ""), preferredStyle: UIAlertControllerStyle.alert)

                alert.addAction(UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: UIAlertActionStyle.default, handler: nil))
                alert.addAction(UIAlertAction(title: NSLocalizedString("accept", comment: ""), style: UIAlertActionStyle.default, handler: { _ in

                    UserDefaults.standard.set(alert.textFields?[0].text ?? "", forKey: "password")
                    tableView.beginUpdates()
                    tableView.reloadRows(at: [indexPath], with: .automatic)
                    tableView.endUpdates()
                }
                ))
                alert.addTextField(configurationHandler: {(textField: UITextField!) in
                    textField.placeholder = ""
                    textField.text = UserDefaults.standard.string(forKey: "password") ?? ""
                    textField.isSecureTextEntry = false // for password input
                })
                self.present(alert, animated: true, completion: nil)
            }
        } else if indexPath.section == 3 && indexPath.row == 0 {
            UserDefaults.standard.set(!UserDefaults.standard.bool(forKey: "health_report"), forKey: "health_report")
            //crash
            tableView.beginUpdates()
            tableView.reloadRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
            
        } else if indexPath.section == 3 && indexPath.row == 1 {
            UserDefaults.standard.set(!UserDefaults.standard.bool(forKey: "usage_data"), forKey: "usage_data")
            //data
            tableView.beginUpdates()
            tableView.reloadRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
            
        }
    }
}
