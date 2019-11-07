//
//  ControllersTabBarVC.swift
//  Messenger
//
//  Created by Vitaliy Paliy on 11/4/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit
import Firebase

class ControllersTabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("TAB BAR")
        let uid = Auth.auth().currentUser?.uid
        Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshot = snapshot.value as? [String: AnyObject]{
                CurrentUserInformation.uid = uid
                CurrentUserInformation.name = snapshot["name"] as? String
                CurrentUserInformation.email = snapshot["email"] as? String
                CurrentUserInformation.profileImage = snapshot["profileImage"] as? String
            }
        }, withCancel: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("TAB BAR DISAPPEARS")
    }
    
}
