//
//  UserInformationVC.swift
//  Messenger
//
//  Created by Vitaliy Paliy on 11/11/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit
import Firebase

class UserInformationVC: UIViewController {
    
    @IBOutlet weak var profileImage: ImageVC!
    @IBOutlet weak var changeImageView: BackgroundView!
    @IBOutlet weak var changeEmail: ButtonVC!
    @IBOutlet weak var changePasswordButton: ButtonVC!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hideTabBar(status: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideTabBar(status: true)
    }
    
    @IBAction func passwordButtonPressed(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(identifier: "UpdatePasswordVC") as! UpdatePasswordVC
        show(controller, sender: nil)
    }
    
    @IBAction func emailButtonPressed(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(identifier: "UpdateEmailVC") as! UpdateEmailVC
        show(controller, sender: nil)
    }
    
}
