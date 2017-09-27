/*
 *   Copyright © 2017 Teclib. All rights reserved.
 *
 * AgentSettingsController.swift is part of FlyveMDMInventoryAgent
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
import FlyveMDMInventory
import Alamofire
import UserNotifications

/// AgentSettingsController class
class AgentSettingsController: UIViewController {
    
    // MARK: Properties

    let cellId = "InventoryCell"
    var disable = true

    /// This property contains the configurations for the table view
    lazy var inventoryTableView: UITableView = {
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

    /// This property contatins the configurations for the footer view
    let footerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()

    /// This property contains the configurations of the message label
    let messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textAlignment = .center
        label.numberOfLines = 0
        label.backgroundColor = .clear
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 15.0, weight: UIFont.Weight.regular)
        return label
    }()

    /// This property contains the configurations of the loading indicator
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
        setupViews()
        addConstraints()
    }

    /// Set up the views of the controller
    func setupViews() {
        view.backgroundColor = .white
        let infoButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "info"),
                                                          style: .plain,
                                                          target: self, action: #selector(openAbout))
        navigationItem.titleView = UIImageView(image: UIImage(named: "logo"))
        navigationItem.rightBarButtonItem = infoButton
        view.addSubview(inventoryTableView)
        view.addSubview(footerView)
        footerView.addSubview(messageLabel)
        footerView.addSubview(loadingIndicatorView)
    }
    
    /// Add the constraints to the views of the controller
    func addConstraints() {
        inventoryTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        inventoryTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        inventoryTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        inventoryTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        footerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        footerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        footerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        footerView.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
        loadingIndicatorView.bottomAnchor.constraint(equalTo: footerView.bottomAnchor, constant: -24).isActive = true
        loadingIndicatorView.centerXAnchor.constraint(equalTo: footerView.centerXAnchor).isActive = true
        messageLabel.bottomAnchor.constraint(equalTo: loadingIndicatorView.topAnchor, constant: -24).isActive = true
        messageLabel.leftAnchor.constraint(equalTo: footerView.leftAnchor, constant: 16).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: footerView.rightAnchor, constant: -16).isActive = true
        messageLabel.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 8).isActive = true
    }
    
    @objc func openAbout() {
        navigationController?.pushViewController(AboutController(), animated: true)
    }

    /**
     Generate XML Inventory
     */
    func generateXML() {
//        "Generating XML Inventory..."
        messageLabel.text = NSLocalizedString("button_start_inventory", comment: "")
        loadingIndicatorView.startAnimating()
        let inventoryTask = InventoryTask()
        inventoryTask.execute("FusionInventory-Agent-iOS_v1.0", tag: UserDefaults.standard.string(forKey: "nameTag") ?? "") { result in
            sendXmlInventory(result)
        }
    }

    /**
     Send XML Inventory
     - parameter: XML inventory
     */
    func sendXmlInventory(_ xml: String) {
//        "Sending XML Inventory..."
        messageLabel.text = NSLocalizedString("inventory_sended", comment: "")

        guard let server = UserDefaults.standard.string(forKey: "nameServer"), !server.isEmpty else {
            messageLabel.text = NSLocalizedString("server_empty", comment: "")
            self.loadingIndicatorView.stopAnimating()
            return
        }

        var headers: HTTPHeaders = [
            "User-Agent": "FusionInventory-Agent-iOS_v1.0",
            "Content-Type": "text/plain; charset=ISO-8859-1"
        ]

        if let user = UserDefaults.standard.string(forKey: "login"), let password = UserDefaults.standard.string(forKey: "password"), !user.isEmpty, !password.isEmpty {

            if let authorizationHeader = Request.authorizationHeader(user: user, password: password) {
                headers[authorizationHeader.key] = authorizationHeader.value
            }
        }

        Alamofire.request(server, method: .post, parameters: [:], encoding: xml, headers: headers)
            .validate(statusCode: 200..<300)
            .responseString { response in

            switch response.result {
            case .success:
                self.messageLabel.text = NSLocalizedString("ok_send_inventory", comment: "")

                if UserDefaults.standard.bool(forKey: "notifications") {

                    if #available(iOS 10.0, *) {
                        let notification = UNMutableNotificationContent()
                        notification.title = NSLocalizedString("service_notif_id", comment: "")
                        notification.subtitle = ""
                        notification.body = NSLocalizedString("ok_send_inventory", comment: "")
                        
                        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                        let request = UNNotificationRequest(identifier: "notificationSuccessful", content: notification, trigger: notificationTrigger)
                        
                        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                    } else {
                        let notification = UILocalNotification()
                        notification.alertTitle = NSLocalizedString("service_notif_id", comment: "")
                        notification.alertBody = NSLocalizedString("ok_send_inventory", comment: "")
                        notification.fireDate = Date(timeIntervalSinceNow: 5)
                        UIApplication.shared.cancelAllLocalNotifications()
                        UIApplication.shared.scheduledLocalNotifications = [notification]
                    }
                }

            case .failure( _):
//                "Error: \(response.result.error?.localizedDescription ?? "failure")"
                self.messageLabel.text = NSLocalizedString("error_send_inventory", comment: "") + "\n\(response.result.error?.localizedDescription ?? "failure")"

                if UserDefaults.standard.bool(forKey: "notifications") {

                    if #available(iOS 10.0, *) {
                        let notification = UNMutableNotificationContent()
                        notification.title = NSLocalizedString("service_notif_id", comment: "")
                        notification.subtitle = ""
                        notification.body = NSLocalizedString("error_send_inventory", comment: "")
                        
                        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                        let request = UNNotificationRequest(identifier: "notificationSuccessful", content: notification, trigger: notificationTrigger)
                        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                    } else {
                        let notification = UILocalNotification()
                        notification.alertTitle = NSLocalizedString("service_notif_id", comment: "")
                        notification.alertBody = NSLocalizedString("error_send_inventory", comment: "")
                        notification.fireDate = Date(timeIntervalSinceNow: 5)
                        UIApplication.shared.cancelAllLocalNotifications()
                        UIApplication.shared.scheduledLocalNotifications = [notification]
                    }
                }
            }
            self.loadingIndicatorView.stopAnimating()
        }
    }
    
    /**
     Enable or Disable run send xml inventory
     */
    @objc func switchAtValueChanged(uiSwitch: UISwitch) {
        if uiSwitch.tag == 777 {
            let indexMe: IndexPath = IndexPath(row: 0, section: 0)
            let index: IndexPath = IndexPath(row: 1, section: 0)
            disable = !disable

            //disable inventory
            inventoryTableView.beginUpdates()
            inventoryTableView.reloadRows(at: [indexMe, index], with: .automatic)
            inventoryTableView.endUpdates()
        }
    }
}

// MARK: UITableViewDataSource
extension AgentSettingsController: UITableViewDataSource {

    /**
     override `numberOfSections` from super class, get number of sections
     
     - return: number of sections
     */
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    /**
     override `numberOfRowsInSection` from super class, get number of row in sections
     
     - return: number of row in sections
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if section == 0 {
            return 2
        } else {
            return 1
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

            let inventorySwitch = UISwitch()
            inventorySwitch.translatesAutoresizingMaskIntoConstraints = false
            inventorySwitch.tag = 777
            inventorySwitch.addTarget(self, action: #selector(self.switchAtValueChanged(uiSwitch:)), for: UIControlEvents.valueChanged)
            cell.textLabel?.text = NSLocalizedString("inventory", comment: "")

            if disable {
                cell.detailTextLabel?.text = NSLocalizedString("inventory_disable", comment: "")
            } else {
                cell.detailTextLabel?.text = NSLocalizedString("inventory_enable", comment: "")
            }

            cell.contentView.addSubview(inventorySwitch)
            inventorySwitch.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor).isActive = true
            inventorySwitch.rightAnchor.constraint(equalTo: cell.contentView.rightAnchor, constant: -16.0).isActive = true
            inventorySwitch.setOn(disable, animated: false)

        } else if indexPath.section == 0 && indexPath.row == 1 {

            cell.isUserInteractionEnabled = disable
            cell.textLabel!.isEnabled = disable
            cell.detailTextLabel!.isEnabled = disable
            cell.textLabel?.text = NSLocalizedString("inventory_run", comment: "")
            cell.detailTextLabel?.text = NSLocalizedString("run", comment: "")

        } else if indexPath.section == 1 && indexPath.row == 0 {
            cell.textLabel?.text = NSLocalizedString("global_title", comment: "")
            cell.detailTextLabel?.text = NSLocalizedString("global_subtitle", comment: "")
        }

        return cell
    }

    /**
     override `titleForHeaderInSection` from super class, set title for header in section
     
     - return: `String`
     */
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        if section == 0 {
            return NSLocalizedString("inventory", comment: "")
        } else {
            return NSLocalizedString("global", comment: "")
        }
    }
}

// MARK: UITableViewDelegate
extension AgentSettingsController: UITableViewDelegate {

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

            let index: IndexPath = IndexPath(row: 1, section: 0)
            disable = !disable

            //disable inventory
            tableView.beginUpdates()
            tableView.reloadRows(at: [indexPath, index], with: .automatic)
            tableView.endUpdates()

        } else if indexPath.section == 0 && indexPath.row == 1 {
            //run now
            generateXML()

        } else if indexPath.section == 1 && indexPath.row == 0 {
            //Global settings
            navigationController?.pushViewController(GlobalSettingsController(), animated: true)
        }
    }

}

// MARK: ParameterEncoding
extension String: ParameterEncoding {
    
    /// :nodoc:
    // override `func encode`
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        return request
    }
}
