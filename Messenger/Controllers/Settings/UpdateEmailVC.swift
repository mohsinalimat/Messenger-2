//
//  UpdateEmailVC.swift
//  Messenger
//
//  Created by Vitaliy Paliy on 11/12/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit
import Firebase

class UpdateEmailVC: UIViewController {

    @IBOutlet weak var newEmailTf: TextFieldVC!
    @IBOutlet weak var confirmEmail: TextFieldVC!
    @IBOutlet weak var confirmButton: ButtonVC!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideTabBar(status: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hideTabBar(status: false)
    }
    
    func validateEmails() -> String? {
        if confirmEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || newEmailTf.text?.trimmingCharacters(in: .whitespacesAndNewlines) ==  "" {
            return "Please fill in all fields"
        }
        
        let newEmail = newEmailTf.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let confirmNew = confirmEmail.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if confirmNew != newEmail {
            return "Please make sure your emails match"
        }
                
        return nil
    }
    

    @IBAction func confirmButtonPressed(_ sender: Any) {
    
        let validation = validateEmails()
        if validation != nil {
            showAlert(title: "Error", message: validation)
            return
        }
        let newEmail = newEmailTf.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        Auth.auth().currentUser?.updateEmail(to: newEmail, completion: { (error) in
            if let error = error {
                self.showAlert(title: "Error Happened!", message: error.localizedDescription)
                return
            }
            self.showAlert(title: "Success", message: "Your email has been changed successfully!")
        })
        
    }
}
