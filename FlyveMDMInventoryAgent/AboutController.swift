/*
 * Copyright © 2017 Teclib. All rights reserved.
 *
 * AboutController.swift is part of FlyveMDMInventoryAgent
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
 * @date      26/09/17
 * @copyright Copyright © 2017 Teclib. All rights reserved.
 * @license   GPLv3 https://www.gnu.org/licenses/gpl-3.0.html
 * @link      https://github.com/flyve-mdm/flyve-mdm-ios-inventory-agent.git
 * @link      https://flyve-mdm.com
 * ------------------------------------------------------------------------------
 */

import UIKit

/// AboutController class
class AboutController: UIViewController {
    
    // MARK: Properties
    
    /// This property contatins the logo for view
    let logoImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "agent")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    /// This property contatins the info about app
    lazy var infoTextView: UITextView = {
        
        let version = NSAttributedString(string: "\(Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? ""), version \(getResource("version")), build \(getResource("build")).\n")
        
        let date = NSAttributedString(string: "Build on \(getResource("date")). ")
        
        let commit = "Last commit \(getResource("commit")).\n"
        let urlCommit = "https://github.com/flyve-mdm/flyve-mdm-ios-inventory-agent/commit/\(getResource("commit_full"))"
        let rangeCommit = NSRange(location: 12, length: commit.characters.count-14)
        let linkCommit = NSMutableAttributedString(string: commit)
        linkCommit.addAttribute(NSAttributedStringKey.link, value: NSURL(string: urlCommit)!, range: rangeCommit)
        
        let teclib = "© Teclib' 2017. "
        let urlTeclib = "http://teclib-edition.com/"
        let rangeTeclib = NSRange(location: 2, length: teclib.characters.count-8)
        let linkTeclib = NSMutableAttributedString(string: teclib)
        linkTeclib.addAttribute(NSAttributedStringKey.link, value: NSURL(string: urlTeclib)!, range: rangeTeclib)
        
        let license = "Licensed under LGPLv3. "
        let urlLicense = "https://www.gnu.org/licenses/lgpl-3.0.html"
        let rangeLicense = NSRange(location: 15, length: license.characters.count-17)
        let linkLicense = NSMutableAttributedString(string: license)
        linkLicense.addAttribute(NSAttributedStringKey.link, value: NSURL(string: urlLicense)!, range: rangeLicense)
        
        let flyve = "Flyve MDM®"
        let urlFlyve = "https://flyve-mdm.com/"
        let rangeFlyve = NSRange(location: 0, length: flyve.characters.count-1)
        let linkFlyve = NSMutableAttributedString(string: flyve)
        linkFlyve.addAttribute(NSAttributedStringKey.link, value: NSURL(string: urlFlyve)!, range: rangeFlyve)
        
        let info = NSMutableAttributedString()
        info.append(version)
        info.append(date)
        info.append(linkCommit)
        info.append(linkTeclib)
        info.append(linkLicense)
        info.append(linkFlyve)
        
        let font = UIFont.systemFont(ofSize: 13.0, weight: UIFont.Weight.light)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.paragraphSpacing = 0.5 * font.lineHeight
        let attributes = [NSAttributedStringKey.font: font, NSAttributedStringKey.paragraphStyle: paragraphStyle]
        
        info.addAttributes(attributes, range: NSRange(location: 0, length: info.string.characters.count))
        
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.attributedText = info
        textView.dataDetectorTypes = .link
        textView.isSelectable = true
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.textAlignment = .center
        textView.textColor = UIColor.darkGray
        textView.backgroundColor = UIColor.clear
        return textView
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
        navigationItem.title = "About"
        view.addSubview(logoImage)
        view.addSubview(infoTextView)
    }
    
    /// Add the constraints to the views of the controller
    func addConstraints() {
        logoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        infoTextView.topAnchor.constraint(equalTo: logoImage.bottomAnchor, constant: 24).isActive = true
        infoTextView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        infoTextView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
        infoTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16).isActive = true
    }
    
    func getResource(_ key: String) -> String {
        return NSLocalizedString(key, tableName: "about", comment: "")
    }
}
