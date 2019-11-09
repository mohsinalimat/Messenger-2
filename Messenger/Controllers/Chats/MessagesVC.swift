//
//  MessagesVC.swift
//  Messenger
//
//  Created by Vitaliy Paliy on 11/6/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit
import Firebase

class MessagesVC: UIViewController, UITextFieldDelegate {
    
    // User outlets
    
    var friendPhoto: String!
    var friendName: String!
    var friendId: String!
    var friendEmail: String!
    
    // Message Outlets
    var messages: [Message] = []
    
    @IBOutlet weak var chatNavigation: UINavigationItem!
    @IBOutlet weak var messageTextfield: UITextField!
    @IBOutlet weak var photoLibrary: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    
    // Navigation Outlets
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        messageTextfield.delegate = self
        chatNavigation.title = friendName
        tableView.register(UINib(nibName: "SenderMessagesCell", bundle: nil), forCellReuseIdentifier: "SenderMessagesCell")
        tableView.register(UINib(nibName: "FriendMessagesCell", bundle: nil), forCellReuseIdentifier: "FriendMessagesCell")
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideTabBar(status: true)
        getUserMessages()
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
            sendMessagesHandler(message, sender)
        }
    }
    
    func sendMessagesHandler(_ message: String,_ sender: String){
        // TODO: Add the person who will recieve this.
        guard let friendId = friendId else { return }
        let values = ["message":message, "sender": sender, "date": Date().timeIntervalSince1970, "friend": friendId] as [String : Any]
        let reference = Constants.FirebaseDB.db.reference().child("messages")
        let childRef = reference.childByAutoId()
        childRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                print("error")
                return
            }
            let userMessagesRef = Constants.FirebaseDB.db.reference().child("friend-messages").child(sender).child(friendId)
            let messageId = childRef.key!
            userMessagesRef.updateChildValues([messageId: 1])
            
            let friendRef = Constants.FirebaseDB.db.reference().child("friend-messages").child(friendId).child(sender)
            friendRef.updateChildValues([messageId: 1])
            
            
            
        }
        messageTextfield.text = ""
        
    }
    
    func getUserMessages(){
        
        let ref = Constants.FirebaseDB.db.reference().child("friend-messages").child(CurrentUserInformation.uid).child(friendId)
        ref.observe(.childAdded, with: { (snapshot) in
            let messageId = snapshot.key
            let messageReference = Constants.FirebaseDB.db.reference().child("messages").child(messageId)
            messageReference.observeSingleEvent(of: .value) { (snapshot) in
                guard let values = snapshot.value as? [String: AnyObject] else { return }
                let message = Message()
                message.message = values["message"] as? String
                message.sender = values["sender"] as? String
                message.time = values["date"] as? NSNumber
                message.friend = values["friend"] as? String
                if message.friendChecker() == self.friendId{
                    self.messages.append(message)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        let indexPath = IndexPath(row: (self.messages.count - 1), section: 0)
                        self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
                    }
                    
                }
            }
        }, withCancel: nil)
    }
    
    @IBAction func photoLibraryPressed(_ sender: Any) {
        
        // TODO: Send photos
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if self.messageTextfield.text?.count == 0 { return false }
        if let message = messageTextfield.text, let sender = Auth.auth().currentUser?.uid {
            sendMessagesHandler(message, sender)
        }
        return true
    }
     
}

extension MessagesVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        let date = NSDate(timeIntervalSince1970: message.time.doubleValue)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        if message.sender == CurrentUserInformation.uid {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SenderMessagesCell") as! SenderMessagesCell
            cell.messagesLabel.text = message.message
            cell.timeLabel.text = dateFormatter.string(from: date as Date)
            return cell
            
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "FriendMessagesCell") as! FriendMessagesCell
            getSenderInfo(sender: message.sender) { (data, error) in
                guard let data = data else { return }
                cell.profileImage.loadImageCacheWithUrlString(imageUrl: data["profileImage"] as! String)
            }
            cell.messageLabel.text = message.message
            cell.timeLabel.text = dateFormatter.string(from: date as Date)
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}
