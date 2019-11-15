//
//  UpdateEmailVC.swift
//  Messenger
//
//  Created by Vitaliy Paliy on 11/12/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit
import Firebase
import Lottie

class UpdateEmailVC: UIViewController {

    @IBOutlet weak var newEmailTf: TextFieldVC!
    @IBOutlet weak var confirmEmail: TextFieldVC!
    @IBOutlet weak var confirmButton: ButtonVC!
    @IBOutlet weak var animationView: AnimationView!
    
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
        
        if newEmail == CurrentUserInformation.email {
            return "The new email should not be the same as your current email "
        }
        
        return nil
    }
    
    func animation(_ status: Bool){
        navigationController?.navigationBar.isUserInteractionEnabled = !status
        newEmailTf.isEnabled = !status
        confirmEmail.isEnabled = !status
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
    
    @IBAction func confirmButtonPressed(_ sender: Any) {
        self.animation(true)
        let validation = validateEmails()
        if validation != nil {
            showAlert(title: "Error", message: validation)
            self.animation(false)
            return
        }
        let newEmail = newEmailTf.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        Auth.auth().currentUser?.updateEmail(to: newEmail, completion: { (error) in
            if let error = error {
                self.showAlert(title: "Error Happened!", message: error.localizedDescription)
                self.animation(false)
                return
            }
            let ref = Constants.FirebaseDB.db.reference().child("users").child(CurrentUserInformation.uid)
            ref.updateChildValues(["email":newEmail])
            CurrentUserInformation.email = newEmail
            self.animation(false)
            self.showAlert(title: "Success", message: "Your email has been changed successfully!")
        })
        
        
    }
}
