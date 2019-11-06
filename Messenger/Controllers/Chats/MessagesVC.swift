//
//  MessagesVC.swift
//  Messenger
//
//  Created by Vitaliy Paliy on 11/6/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit
import Firebase

class MessagesVC: UIViewController {
    
    // Message Outlets
    
    let db = Firestore.firestore()
    
    var texts = ["One of the most effective ways to get new users to install your app is by enabling your users to share content from your app with their friends. With Dynamic Links, you can create a great user-to-user sharing experience: users who receive content recommendations from their friends can click a link and be taken directly to the shared content in your app, even if they have to go to the App Store or Google Play Store to install your app first.One of the most effective ways to get new users to install your app is by enabling your users to share content from your app with their friends. With Dynamic Links, you can create a great user-to-user sharing experience: users who receive content recommendations from their friends can click a link and be taken directly to the shared content in your app, even if they have to go to the App Store or Google Play Store to install your app first.","Hi","What's up?"]
    
    @IBOutlet weak var messageTextfield: UITextField!
    @IBOutlet weak var photoLibrary: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    
    // Navigation Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var chatNavigation: UINavigationItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MessagesCell", bundle: nil), forCellReuseIdentifier: "MessagesCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideTabBar(status: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hideTabBar(status: false)
    }
    @IBAction func addButtonPressed(_ sender: Any) {
        // TODO: Add info about the user.
        print("Hi")
        
    }
    @IBAction func sendButtonPressed(_ sender: Any) {
        if let message = messageTextfield.text, let sender = CurrentUserInformation.email {
            sendButton.isEnabled = true
            sendMessagesHandler(message, sender)
            
        }
    }
    
    func sendMessagesHandler(_ message: String,_ sender: String){
        let values = ["message":message, "sender": sender]
        db.collection("messages").addDocument(data: values) { (error) in
            if let error = error {
                self.showAlert(title: "Error", message: error.localizedDescription)
                return
            }
            print("Data was saved")
            
        }
    }
    
    @IBAction func photoLibraryPressed(_ sender: Any) {
        
        
    }
}
extension MessagesVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return texts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessagesCell") as! MessagesCell
        cell.messageLabel.text = texts[indexPath.row]
        cell.userImage.loadImageCacheWithUrlString(imageUrl: CurrentUserInformation.profileImage)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

