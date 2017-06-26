/*
 *   Copyright © 2017 Teclib. All rights reserved.
 *
 * ViewController.swift is part of FusionInventory
 *
 * FusionInventory is a subproject of Flyve MDM. Flyve MDM is a mobile
 * device management software.
 *
 * FusionInventory is free software: you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 3
 * of the License, or (at your option) any later version.
 *
 * Example is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * ------------------------------------------------------------------------------
 * @author    Hector Rondon
 * @date      22/06/17
 * @copyright Copyright © 2017 Teclib. All rights reserved.
 * @license   GPLv3 https://www.gnu.org/licenses/gpl-3.0.html
 * @link      https://github.com/flyve-mdm/fusioninventory-ios
 * @link      https://flyve-mdm.com
 * ------------------------------------------------------------------------------
 */

import UIKit
import FlyveMDMInventory
import Alamofire

class ViewController: UIViewController {
    
    let cellId = "InventoryCell"
    
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
    
    let logoImageView: UIImageView = {
        
        let imageView = UIImageView(image: UIImage(named: "logo"))
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = false
        
        return imageView
    }()
    
    let messageLabel: UILabel = {
        
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.sizeToFit()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.textColor = .gray
        
        return label
    }()
    
    let loadingIndicatorView: UIActivityIndicatorView = {
        
        let loading = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        
        loading.color = .gray
        loading.translatesAutoresizingMaskIntoConstraints = false
        loading.hidesWhenStopped = true
        
        return loading
    }()
    
    lazy var postButton: UIButton = {

        let button = UIButton(type: UIButtonType.custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.backgroundColor = UIColor.white.cgColor
        button.layer.borderColor = UIColor.darkGray.cgColor
        button.setTitle("Run inventory now", for: .normal)
        button.setTitleColor(UIColor.darkGray, for: .normal)
        button.addTarget(self, action: #selector(self.generateXML), for: .touchUpInside)
        return button
    }()
    
    override func loadView() {
        super.loadView()
        
        setupViews()
        addConstraints()
    }
    
    func setupViews() {
        
        view.backgroundColor = .white
        
        navigationItem.titleView = UIImageView(image: UIImage(named: "logo"))
        
        view.addSubview(inventoryTableView)
        view.addSubview(loadingIndicatorView)
    }
    
    func addConstraints() {
        
        inventoryTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        inventoryTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        inventoryTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        inventoryTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        loadingIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadingIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        
    }
    
    func generateXML() {
        
        messageLabel.text = "Generating XML Inventory..."
        loadingIndicatorView.startAnimating()
        
        let inventoryTask = InventoryTask()
        
        inventoryTask.execute("FusionInventory-Agent-iOS_v1.0") { result in

            sendXmlInventory(result)
        }
    }
    
    func sendXmlInventory(_ xml: String) {
        
        messageLabel.text = "Sending XML Inventory..."
        
        let headers: HTTPHeaders = [
            "User-Agent": "FusionInventory-Agent-iOS_v1.0",
            "Content-Type": "text/plain; charset=ISO-8859-1"
        ]
        
        Alamofire.request("https://dev.flyve.org/glpi/plugins/fusioninventory/", method: .post, parameters: [:], encoding: xml, headers: headers).responseString { response in
            
            print("Response String: \(response.result.value ?? "Response Empty")")
            
            self.messageLabel.text = "\(response.result.value ?? "Response Empty")"
            self.loadingIndicatorView.stopAnimating()
        }
    }
}

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 2
        } else {
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: cellId)
        
        if indexPath.section == 0 && indexPath.row == 0 {
            
            cell.textLabel?.text = "Inventory"
            cell.detailTextLabel?.text = "Click to disable inventory"
            
        } else if indexPath.section == 0 && indexPath.row == 1 {
            
            cell.textLabel?.text = "Run inventory now"
            cell.detailTextLabel?.text = "Run now"
        } else if indexPath.section == 1 && indexPath.row == 0 {
            
            cell.textLabel?.text = "Global settings"
            cell.detailTextLabel?.text = "Setup, certificates, server..."
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 0 {
            return "Inventory"
        } else {
            return "Global"
        }
        
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        if let headerView = view as? UITableViewHeaderFooterView, let textLabel = headerView.textLabel {
            
            headerView.backgroundView?.backgroundColor = UIColor.init(red: 239.0/255.0, green: 239.0/255.0, blue: 244.0/255.0, alpha: 1.0)
            
            textLabel.font = UIFont.systemFont(ofSize: 12.0, weight: UIFontWeightBold)
            textLabel.textColor = UIColor.gray
        }
    }

}

extension String: ParameterEncoding {
    
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        return request
    }
    
}

class InventoryCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = UITableViewCellSelectionStyle.none
        contentView.backgroundColor = .clear
        
        setupViews()
        addConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
    
    }
    
    func addConstraints() {
    
    }
}

