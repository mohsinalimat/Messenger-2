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
    
    // Outlets
    
    @IBOutlet weak var usernameTextField: TextFieldVC!
    @IBOutlet weak var passwordTextField: TextFieldVC!
    @IBOutlet weak var signInButton: ButtonVC!
    @IBOutlet weak var animationView: AnimationView!
    
    // This method starts/stops loading animation
    
    func animation(_ status: Bool){
        animationView.isHidden = !status
        usernameTextField.isEnabled = !status
        passwordTextField.isEnabled = !status
        signInButton.isEnabled = !status
        if status {
            animationView.animation = Animation.named("loading")
            animationView.loopMode = .loop
            animationView.play()
        }else{
            animationView.stop()
        }
    }
    
    @IBAction func signInButtonClicked(_ sender: Any) {
        animation(true)
        handleLogin()
    }
    
    @IBAction func signUpButtonClicked(_ sender: Any) {
        
        let controller = storyboard?.instantiateViewController(identifier: Constants.Storyboard.signUpVC) as! SignUpVC
        present(controller, animated: true, completion: nil)
    }
    
    // This method handles login
    
    func handleLogin(){
        let textFieldError = validateTextFields()
        if textFieldError != nil {
            showAlert(title: "Error happened!", message: textFieldError)
            self.animation(false)
            return
        }else{
            let email = usernameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                if error != nil {
                    self.showAlert(title: "Error", message: error?.localizedDescription)
                }else{
                    self.nextController()
                }
                self.animation(false)
            }
        }
        
    }
    
    // Validates text fields
    
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

