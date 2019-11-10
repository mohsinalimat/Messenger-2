//
//  AddNewFriendVC.swift
//  Messenger
//
//  Created by Vitaliy Paliy on 11/6/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit
import Firebase

class AddNewFriendVC: UIViewController {
    
    //    TODO: Change the condintion of the Add button if users interact with it.
    
    var name: String!
    var email: String!
    var profileImageUrl: String!
    var friendId: String!
    var isYourFriend: Bool!
    
    @IBOutlet weak var profileImage: ImageVC!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = name
        emailLabel.text = email
        profileImage.loadImageCacheWithUrlString(imageUrl: profileImageUrl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideTabBar(status: true)
    }
    
    
    @IBAction func addFriendButton(_ sender: Any) {
        addFriendHandler()
    }
    
    
    func addFriendHandler(){
        if isYourFriend == nil || !isYourFriend {
            let ref = Constants.FirebaseDB.db.reference().child("users")
            let currentFriendsRef = ref.child(CurrentUserInformation.uid).child("friends")
            currentFriendsRef.child(friendId).setValue(true)
            let newFriendRef = ref.child(friendId).child("friends")
            newFriendRef.child(CurrentUserInformation.uid).setValue(true)
            showAlert(title: "Success", message: "This user was added as your friend.")
        }else{
            showAlert(title: "OK", message: "This user is already in your friends list.")
        }
    }
    
}
