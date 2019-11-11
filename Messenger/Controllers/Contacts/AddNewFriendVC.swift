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
    @IBOutlet weak var addFriendButton: ButtonVC!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = name
        emailLabel.text = email
        friendChecker(isYourFriend)
        profileImage.loadImageCacheWithUrlString(imageUrl: profileImageUrl)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideTabBar(status: true)
    }
    
    
    @IBAction func addFriendButton(_ sender: Any) {
        addFriendHandler()
    }
    
    func friendChecker(_ status: Bool){
        if status {
            addFriendButton.backgroundColor = .systemRed
            addFriendButton.setTitle("Remove Friend", for: .normal)
        }else if !status {
            addFriendButton.backgroundColor = .systemGreen
            addFriendButton.setTitle("Add Friend", for: .normal)
        }
    }
    
    func addFriendHandler(){
        if !isYourFriend{
            let ref = Constants.FirebaseDB.db.reference().child("users")
            let currentFriendsRef = ref.child(CurrentUserInformation.uid).child("friends")
            currentFriendsRef.child(friendId).setValue(true)
            let newFriendRef = ref.child(friendId).child("friends")
            newFriendRef.child(CurrentUserInformation.uid).setValue(true)
            isYourFriend = true
        }else{
            let ref = Constants.FirebaseDB.db.reference().child("users").child(CurrentUserInformation.uid).child("friends")
            ref.updateChildValues([friendId: false])
            let friendRef = Constants.FirebaseDB.db.reference().child("users").child(friendId).child("friends")
            friendRef.updateChildValues([CurrentUserInformation.uid: false])
            isYourFriend = false            
        }
        friendChecker(isYourFriend)
    }
    
}
