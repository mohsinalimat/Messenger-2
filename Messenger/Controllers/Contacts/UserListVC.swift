//
//  AddNewUserVC.swift
//  Messenger
//
//  Created by Vitaliy Paliy on 11/5/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit
import Firebase

class UserListVC: UIViewController {
    
    var usersInformation = [UserInformation]()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        fetchUser()
        
    }
    
    func fetchUser(){
        Database.database().reference().child("users").observe(.childAdded, with: { (data) in
            
            if let snapshot = data.value as? [String: AnyObject] {
                let user = UserInformation()
                user.name = snapshot["name"] as? String
                user.email = snapshot["email"] as? String
                user.profileImage = snapshot["profileImage"] as? String
                user.id = data.key
                self.usersInformation.append(user)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            
        }, withCancel: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideTabBar(status: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hideTabBar(status: false)
    }
    
}

extension UserListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersInformation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserListCell") as! UserListCell
        let user = usersInformation[indexPath.row]
        cell.emailLabel.text = user.email
        cell.nameLabel.text = user.name
        tableView.rowHeight = 100
        cell.profileImage.loadImageCacheWithUrlString(imageUrl: user.profileImage!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let user = usersInformation[indexPath.row]
        let controller = storyboard?.instantiateViewController(identifier: "AddNewFriendVC") as! AddNewFriendVC
        controller.email = user.email
        controller.name = user.name
        controller.profileImageUrl = user.profileImage
        show(controller, sender: nil)
    }
    
}
