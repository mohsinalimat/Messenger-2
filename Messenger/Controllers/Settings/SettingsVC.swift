//
//  SettingsVC.swift
//  Messenger
//
//  Created by Vitaliy Paliy on 11/4/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit
import Firebase

class SettingsVC: UIViewController {

    var userName = String()
    var userEmail = String()

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUserInfo()
    }
    
    func getUserInfo() {
        let uid = Auth.auth().currentUser?.uid
        Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshot = snapshot.value as? [String: AnyObject]{
                self.userName = snapshot["name"] as! String
                self.userEmail = snapshot["email"] as! String
                self.tableView.reloadData()
            }
        }, withCancel: nil)
    }

    @IBAction func logoutButtonPressed(_ sender: Any) {
        signOutHandler()
    }
    
    func signOutHandler(){
        do{
            try Auth.auth().signOut()
        }catch{
            print("Error Logout: \(error.localizedDescription)")
        }
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = mainStoryboard.instantiateViewController(identifier: "SignInVC") as! SignInVC
        view.window?.rootViewController = controller
        view.window?.makeKeyAndVisible()
    }
    
}

extension SettingsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell") as! UserInfoTableViewCell
        cell.nameLabel.text = userName
        cell.emailLabel.text = userEmail
        tableView.rowHeight = 100
        return cell
    }

    
}
