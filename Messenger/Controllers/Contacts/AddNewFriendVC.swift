//
//  AddNewFriendVC.swift
//  Messenger
//
//  Created by Vitaliy Paliy on 11/6/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit
import Firebase

class AddNewFriendVC: UIViewController {
    
    var name: String!
    var email: String!
    var profileImageUrl: String!
    
    @IBOutlet weak var profileImage: ImageVC!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = name
        emailLabel.text = email
        profileImage.loadImageCacheWithUrlString(imageUrl: profileImageUrl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideTabBar(status: true)
        hideNavBar(status: true)
        navigationController?.navigationBar.isHidden = true
    }
            
    @IBAction func addFriendPressed(_ sender: Any) {
        hideTabBar(status: false)
        hideNavBar(status: false)
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    @IBAction func backButtonPressed(_ sender: Any) {
        hideTabBar(status: false)
        hideNavBar(status: false)
        self.navigationController?.popViewController(animated: true)
    }
}
