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
    
    var name: String!
    var email: String!
    var profileImageUrl: String!
    var friendId: String!
    var isYourFriend: Bool!
    
    let db = Database.database()
    
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
    
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        
        if sender.tag == 0 {
            self.navigationController?.popViewController(animated: true)
            hideTabBar(status: false)
        }
        if sender.tag == 1 {
            print("Hi")
            addFriendHandler()
        }
    }
    
    func addFriendHandler(){
        if !isYourFriend {
            let ref = db.reference().child("users")
            let currentFriendsRef = ref.child(CurrentUserInformation.uid).child("friends")
            currentFriendsRef.child(friendId).setValue(true)
            print("completed")
            let newFriendRef = ref.child(friendId).child("friends")
            newFriendRef.child(CurrentUserInformation.uid).setValue(true)
        }else{
            print("this")
            let alert = UIAlertController(title: "Error", message: "This user is already in your friends list", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
}
