/*
 *   Copyright © 2017 Teclib. All rights reserved.
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
 * @author    Hector Rondon
 * @date      27/06/17
 * @copyright Copyright © 2017 Teclib. All rights reserved.
 * @license   GPLv3 https://www.gnu.org/licenses/gpl-3.0.html
 * @link      https://github.com/flyve-mdm/flyve-mdm-ios-inventory-agent.git
 * @link      https://flyve-mdm.com
 * ------------------------------------------------------------------------------
 */

import UIKit

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
        table.isScrollEnabled = false
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

    /// This property contains the configurations for the message label
    let messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.sizeToFit()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 15.0, weight: UIFontWeightRegular)
        return label
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
    
    /// `override loadView()`
    override func loadView() {
        super.loadView()

        setupViews()
        addConstraints()
    }
    
    /// `setupViews()`
    func setupViews() {
        view.backgroundColor = .white
        navigationItem.titleView = UIImageView(image: UIImage(named: "logo"))
        view.addSubview(settingsTableView)
        view.addSubview(footerView)
        footerView.addSubview(messageLabel)
        footerView.addSubview(loadingIndicatorView)
    }
    
    /// `addConstraints()`
    func addConstraints() {
        settingsTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        settingsTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        settingsTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        settingsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        footerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        footerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        footerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        footerView.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
        loadingIndicatorView.bottomAnchor.constraint(equalTo: footerView.bottomAnchor, constant: -24).isActive = true
        loadingIndicatorView.centerXAnchor.constraint(equalTo: footerView.centerXAnchor).isActive = true
        messageLabel.bottomAnchor.constraint(equalTo: loadingIndicatorView.topAnchor, constant: -24).isActive = true
        messageLabel.leftAnchor.constraint(equalTo: footerView.leftAnchor).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: footerView.rightAnchor).isActive = true
        messageLabel.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 8).isActive = true
    }
    
    /**
     Enable or Disable notifications
     */
    func switchAtValueChanged(uiSwitch: UISwitch) {
        if uiSwitch.tag == 777 {
            let index: IndexPath = IndexPath(row: 0, section: 0)
            UserDefaults.standard.set(!UserDefaults.standard.bool(forKey: "notifications"), forKey: "notifications")
            //disable inventory
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
        return 3
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

            if UserDefaults.standard.string(forKey: "nameServer") != "" {
                cell.detailTextLabel?.text = UserDefaults.standard.string(forKey: "nameServer") ?? NSLocalizedString("server_input", comment: "")
            } else {
                cell.detailTextLabel?.text = NSLocalizedString("server_input", comment: "")
            }

        } else if indexPath.section == 1 && indexPath.row == 1 {
            cell.textLabel?.text = NSLocalizedString("tag", comment: "")

            if UserDefaults.standard.string(forKey: "nameTag") != "" {
                cell.detailTextLabel?.text = UserDefaults.standard.string(forKey: "nameTag") ?? ""
            } else {
                cell.detailTextLabel?.text = ""
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
        } else {
            return NSLocalizedString("authentication_credentials", comment: "")
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
            textLabel.font = UIFont.systemFont(ofSize: 12.0, weight: UIFontWeightBold)
            textLabel.textColor = UIColor.gray
        }
    }

    /**
     override `didSelectRowAt` from super class, tells the delegate that the specified row is now selected
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            UserDefaults.standard.set(!UserDefaults.standard.bool(forKey: "notifications"), forKey: "notifications")
            //notifications
            tableView.beginUpdates()
            tableView.reloadRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()

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
        }
    }
}
