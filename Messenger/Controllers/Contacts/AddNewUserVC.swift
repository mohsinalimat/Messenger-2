//
//  AddNewUserVC.swift
//  Messenger
//
//  Created by Vitaliy Paliy on 11/5/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit
import Firebase

class AddNewUserVC: UIViewController {

    var usersInformation = [UserInformation]()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        fetchUser()
        
    }
    
    func fetchUser(){
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            
            if let snapshot = snapshot.value as? [String: AnyObject] {
                let user = UserInformation()
                user.name = snapshot["name"] as? String
                user.email = snapshot["email"] as? String
                user.profileImage = snapshot["profileImage"] as? String
                self.usersInformation.append(user)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            
        }, withCancel: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }

}

extension AddNewUserVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersInformation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddNewUserCell") as! AddNewUserCell
        let user = usersInformation[indexPath.row]
        cell.emailLabel.text = user.email
        cell.nameLabel.text = user.name
        tableView.rowHeight = 100
        if let profileImageUrl = user.profileImage {
            downloadImages(url: profileImageUrl) { (data, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                if let data = data {
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        cell.profileImage.image = image
                        cell.setNeedsLayout()
                    }
                }
                
            }
        }
        
        return cell
    }
    
    
    
    
}
