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
            self.observeMessages()
        }, withCancel: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("TAB BAR DISAPPEARS")
    }
    
    func observeMessages(){
        print("Hi")
        let ref = Constants.FirebaseDB.db.reference().child("friend-messages").child(CurrentUserInformation.uid)
        ref.observe(.childAdded) { (snap) in
            let userId = snap.key
            Constants.FirebaseDB.db.reference().child("friend-messages").child(CurrentUserInformation.uid).child(userId).observe(.childAdded) { (snap) in
                let messageId = snap.key
                Constants.FirebaseDB.db.reference().child("messages").child(messageId).observeSingleEvent(of: .value) { (snapshot) in
                    guard let values = snapshot.value as? [String: AnyObject] else { return }
                    let message = Message()
                    message.message = values["message"] as? String
                    message.sender = values["sender"] as? String
                    message.time = values["date"] as? NSNumber
                    message.friend = values["friend"] as? String
                    message.mediaUrl = values["mediaUrl"] as? String
                    Constants.Model.model.append(message)
                }
            }
        }
    }
    
}
