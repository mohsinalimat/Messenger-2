//
//  LoginVC.swift
//  Messenger
//
//  Created by Vitaliy Paliy on 11/2/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginVC: UIViewController {
    
    @IBOutlet weak var usernameTextField: TextFieldVC!
    @IBOutlet weak var passwordTextField: TextFieldVC!
    @IBOutlet weak var signInButton: ButtonVC!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func signInButtonClicked(_ sender: Any) {
        handleLogin()
    }
    
    @IBAction func signUpButtonClicked(_ sender: Any) {
        
        let controller = storyboard?.instantiateViewController(identifier: Constants.Storyboard.signUpVC) as! SignUpVC
        show(controller, sender: nil)
        
    }
        
    func handleLogin(){
        let textFieldError = validateTextFields()
        if textFieldError != nil {
            showAlert(title: "Error happened!", message: textFieldError)
        }else{
            let email = usernameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                if error != nil {
                    self.showAlert(title: "Error", message: error?.localizedDescription)
                }else{
                    self.nextController()
                }
            }
        }
    }
    
    func validateTextFields() -> String? {
        if usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields"
        }
        
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if password.count < 6 {
            return "Password should be at least 6 characters long."
        }
        
        return nil
    }
    
    // This method gets triggered when the auth was successful
    
    func nextController(){
        let controller = storyboard?.instantiateViewController(identifier: Constants.Storyboard.listTableVC) as! ListTableVC
        show(controller, sender: nil)
    }
    
    
}

