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
    var messages: [Message] = []
    let db = Firestore.firestore()
        
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
        getMessagesHandler()
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
        if self.messageTextfield.text?.count == 0 { return }
        if let message = messageTextfield.text, let sender = Auth.auth().currentUser?.uid {
            sendButton.isEnabled = true
            sendMessagesHandler(message, sender)
            
        }
    }
    
    func sendMessagesHandler(_ message: String,_ sender: String){
        // TODO: Add the person who will recieve this.
        let values = ["message":message, "sender": sender, "date": Date().timeIntervalSince1970] as [String : Any]
        db.collection("messages").addDocument(data: values) { (error) in
            if let error = error {
                self.showAlert(title: "Error", message: error.localizedDescription)
                return
            }
            print("Data was saved")
        }
    }
    
    func getMessagesHandler(){
        
        db.collection("messages").order(by: "date").addSnapshotListener { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let snapshot = snapshot else {
                print("Snapshot is nil")
                return
            }
            self.messages = []
            for values in snapshot.documents {
                let data = values.data()
                if let sender = data["sender"] as? String, let message = data["message"] as? String, let time = data["date"]{
                    let newMessage = Message(message: message, sender: sender, time: time as! NSNumber)
                    self.messages.append(newMessage)
                    self.messageTextfield.text = ""
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
                
            }
        }
        
    }
    
    
    @IBAction func photoLibraryPressed(_ sender: Any) {
        
        
    }
}
extension MessagesVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessagesCell") as! MessagesCell
        let message = messages[indexPath.row]
        cell.messageLabel.text = message.message
        if messages.count > 0 {
            let date = NSDate(timeIntervalSince1970: message.time.doubleValue)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm a"
            cell.timeLabel.text = dateFormatter.string(from: date as Date)
            cell.userImage.loadImageCacheWithUrlString(imageUrl: CurrentUserInformation.profileImage)
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
