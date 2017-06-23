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
        
        let loading = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        
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
        
        view.addSubview(messageLabel)
        view.addSubview(logoImageView)
        view.addSubview(loadingIndicatorView)
        view.addSubview(postButton)
    }
    
    func addConstraints() {
        
        
        logoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 48).isActive = true
        logoImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -48).isActive = true
        logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        postButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -24).isActive = true
        postButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24).isActive = true
        postButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24).isActive = true
        postButton.heightAnchor.constraint(equalToConstant: 50)
        
        loadingIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadingIndicatorView.bottomAnchor.constraint(equalTo: postButton.topAnchor, constant: -24).isActive = true
        
        messageLabel.bottomAnchor.constraint(equalTo: loadingIndicatorView.topAnchor, constant: -16).isActive = true
        messageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24).isActive = true
        messageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24).isActive = true
        
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

extension String: ParameterEncoding {
    
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        return request
    }
    
}

