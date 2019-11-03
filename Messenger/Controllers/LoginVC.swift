//
//  LoginVC.swift
//  Messenger
//
//  Created by Vitaliy Paliy on 11/2/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    
    @IBOutlet weak var usernameTextField: TextFieldVC!
    @IBOutlet weak var passwordTextField: TextFieldVC!
    @IBOutlet weak var signInButton: ButtonVC!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func signInButtonClicked(_ sender: Any) {
    
        
    
    }
    
    @IBAction func signUpButtonClicked(_ sender: Any) {
    
        let controller = storyboard?.instantiateViewController(identifier: "SignUpVC") as! SignUpVC
        show(controller, sender: nil)
        
    }
    
    
}

