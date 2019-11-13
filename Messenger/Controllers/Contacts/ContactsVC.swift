//
//  ContactsVC.swift
//  Messenger
//
//  Created by Vitaliy Paliy on 11/4/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit
import Firebase

class ContactsVC: UIViewController {
    
    var contacts = [UserInformation]()
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        contacts = []
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getContacts()
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
        let controller = storyboard?.instantiateViewController(withIdentifier: "UserListVC") as! UserListVC
        show(controller,sender: nil)
        
    }
    
    func getContacts(){
        Constants.FirebaseDB.db.reference().child("users").observe(.childAdded) { (data) in
            guard let snapshot = data.value as? [String: Any] else { return }
            let user = UserInformation()
            user.name = snapshot["name"] as? String
            user.email = snapshot["email"] as? String
            user.profileImage = snapshot["profileImage"] as? String
            user.id = data.key
            guard let dict = snapshot["friends"] as? [String:Int] else { return }
            if dict[CurrentUserInformation.uid] == 1 {
                user.friend = true
                DispatchQueue.main.async {
                    self.contacts.append(user)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
}

extension ContactsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactsCell") as! ContactsCell
        let friend = contacts[indexPath.row]
        cell.emailLabel.text = friend.email
        cell.userLabel.text = friend.name
        if let url = friend.profileImage {
            cell.profileImage.loadImageCacheWithUrlString(imageUrl: url)
            cell.setNeedsLayout()
        }
        tableView.rowHeight = 100
        return cell
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let friend = contacts[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        let controller = storyboard?.instantiateViewController(identifier: "FriendInfoVC") as! FriendInfoVC
        controller.friendName = friend.name
        controller.friendEmail = friend.email
        controller.friendImage = friend.profileImage
        controller.isFriend = friend.friend
        show(controller, sender: nil)
    }
    
    
}

