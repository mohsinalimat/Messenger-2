//
//  UpdatePasswordVC.swift
//  Messenger
//
//  Created by Vitaliy Paliy on 11/12/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit
import Firebase
import Lottie
class UpdatePasswordVC: UIViewController {
    
    @IBOutlet weak var newPasswordTf: TextFieldVC!
    @IBOutlet weak var confirmNewPasswordTf: TextFieldVC!
    @IBOutlet weak var confirmButton: ButtonVC!
    @IBOutlet weak var animationView: AnimationView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideTabBar(status: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hideTabBar(status: false)
    }
    
    func animation(_ status: Bool){
        navigationController?.navigationBar.isUserInteractionEnabled = !status
        newPasswordTf.isEnabled = !status
        confirmNewPasswordTf.isEnabled = !status
        confirmButton.isEnabled = !status
        animationView.isHidden = !status
        if status {
            animationView.animation = Animation.named("loading")
            animationView.loopMode = .loop
            animationView.play()
        }else{
            animationView.stop()
        }
    }
    
    func validatePasswords() -> String? {
        if newPasswordTf.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || confirmNewPasswordTf.text?.trimmingCharacters(in: .whitespacesAndNewlines) ==  "" {
            return "Please fill in all fields"
        }
        
        let newPassword = newPasswordTf.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let confirmPassword = confirmNewPasswordTf.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if newPassword != confirmPassword {
            return "Please make sure your passwords match"
        }
        
        if newPassword.count < 6 {
            return "Your new password should be at least 6 characters long."
        }
        
        return nil
    }
    
    @IBAction func confirmPressed(_ sender: Any) {
        self.animation(true)
        let passwordValidation = validatePasswords()
        if passwordValidation != nil {
            showAlert(title: "Error", message: passwordValidation)
            self.animation(false)
            return
        }
        let newPassword = newPasswordTf.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        Auth.auth().currentUser?.updatePassword(to: newPassword, completion: { (error) in
            if let error = error {
                self.showAlert(title: "Error Happened!", message: error.localizedDescription)
                self.animation(false)
                return
            }
            self.animation(false)
            self.showAlert(title: "Success", message: "Your password has been changed successfully!")
        })
        
    }
    
}
