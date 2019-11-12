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
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        signOutHandler()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
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
    
    func nextController() {
        let controller = storyboard?.instantiateViewController(identifier: "UserInformationVC") as! UserInformationVC
        show(controller, sender: nil)
    }
     
}

extension SettingsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell") as! UserInfoTableViewCell
        cell.nameLabel.text = CurrentUserInformation.name
        cell.emailLabel.text = CurrentUserInformation.email
        cell.userPhoto.loadImageCacheWithUrlString(imageUrl: CurrentUserInformation.profileImage)
        cell.setNeedsLayout()
        tableView.rowHeight = 100
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        nextController()
    }
    
}
