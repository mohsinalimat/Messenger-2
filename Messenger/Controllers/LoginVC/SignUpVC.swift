//
//  SignUpVC.swift
//  Messenger
//
//  Created by Vitaliy Paliy on 11/3/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import Lottie

class SignUpVC: UIViewController {
    
    // Outlets
    
    @IBOutlet weak var signUpButton: ButtonVC!
    @IBOutlet weak var passwordTextField: TextFieldVC!
    @IBOutlet weak var emailTextField: TextFieldVC!
    @IBOutlet weak var nameTextField: TextFieldVC!
    @IBOutlet weak var lastNameTextField: TextFieldVC!
    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet weak var backButton: ButtonVC!
        
    @IBAction func backButtonClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // This method starts/stops loading animation
    
    func animation(_ status: Bool){
        animationView.isHidden = !status
        emailTextField.isEnabled = !status
        lastNameTextField.isEnabled = !status
        nameTextField.isEnabled = !status
        passwordTextField.isEnabled = !status
        signUpButton.isEnabled = !status
        backButton.isEnabled = !status
        if status {
            animationView.animation = Animation.named("loading")
            animationView.loopMode = .loop
            animationView.play()
        }else{
            animationView.stop()
        }
    }
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        animation(true)
        handleRegister()
    }
    
    // Validates text fields
    
    func validate() -> String? {
        if nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "", lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            return "Please fill in all fields"
        }
        
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let name = nameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if name.count < 2 {
            return "First name should be more than 2 characters long."
        }else if lastName.count < 2 {
            return "Last name should be more than 2 characters long."
        }else if (lastName + name).count > 30 {
            return "Your name should not be more than 15 characters long."
        }

        if password.count < 6 {
            return "Password should be at least 6 characters long"
        }
        
        return nil
    }
    
    // This method handles registration process
    
    func handleRegister(){
        let textFieldError = validate()
        if textFieldError != nil {
            showAlert(title: "Error happened!", message: textFieldError)
            return animation(false)
        }else{
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let name = nameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let fullName = "\(name) \(lastName)"
            Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                self.showAlert(title: "Error happened!", message: error.localizedDescription)
                return
            }
            guard let uid = result?.user.uid else {
                return
            }
                self.nextController(email: email, password: password, name: fullName, uid: uid)
                self.animation(false)
            }
            
        }
        
    }
    
    // This method gets triggered when the auth was successful
    
    func nextController(email: String, password: String, name: String, uid: String){
        let controller = storyboard?.instantiateViewController(identifier: "SignUpAddImageVC") as! SignUpAddImageVC
        controller.email = email
        controller.password = password
        controller.name = name
        controller.uid = uid
        show(controller, sender: nil)
    }
    
    
}
