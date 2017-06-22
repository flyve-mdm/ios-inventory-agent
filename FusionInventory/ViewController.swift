//
//  ViewController.swift
//  FusionInventory
//
//  Created by Hector Rondon on 22/06/17.
//  Copyright © 2017 Teclib. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let logoImageView: UIImageView = {
        
        let imageView = UIImageView(image: UIImage(named: "logo"))
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
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
        
        let button = UIButton(type: .custom)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.backgroundColor = UIColor.init(red: 6.0/255.0, green: 135.0/255.0, blue: 133.0/255.0, alpha: 1.0).cgColor
        button.setTitle("Post XML Inventory", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(self.sendXmlInventory), for: .touchUpInside)
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
        
        
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        messageLabel.bottomAnchor.constraint(equalTo: logoImageView.topAnchor, constant: -16).isActive = true
        messageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24).isActive = true
        messageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24).isActive = true
        
        loadingIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadingIndicatorView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 16).isActive = true
        
        postButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -24).isActive = true
        postButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24).isActive = true
        postButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24).isActive = true
        
        postButton.heightAnchor.constraint(equalToConstant: 50)
        
    }
    
    func sendXmlInventory() {
    
    }
}

