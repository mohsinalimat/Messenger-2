//
//  SignInVC.swift
//  Messenger
//
//  Created by Vitaliy Paliy on 11/2/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit
import Lottie
import FirebaseAuth

class SignInVC: UIViewController {
    
    @IBOutlet weak var usernameTextField: TextFieldVC!
    @IBOutlet weak var passwordTextField: TextFieldVC!
    @IBOutlet weak var signInButton: ButtonVC!
    @IBOutlet weak var animationView: AnimationView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animationView.isHidden = false
    }
    
    func animation(_ status: Bool){
        animationView.isHidden = !status
        if status {
            animationView.animation = Animation.named("loading")
            animationView.loopMode = .loop
            animationView.play()
        }else{
            animationView.stop()
        }
        usernameTextField.isEnabled = !status
        passwordTextField.isEnabled = !status
        signInButton.isEnabled = !status
    }
    
    @IBAction func signInButtonClicked(_ sender: Any) {
        animation(true)
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
        animation(false)
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
        
        performSegue(withIdentifier: Constants.Storyboard.controllersTabBar, sender: nil)
        
    }
    
    
}

