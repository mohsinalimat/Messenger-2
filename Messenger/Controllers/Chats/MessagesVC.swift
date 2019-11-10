//
//  MessagesVC.swift
//  Messenger
//
//  Created by Vitaliy Paliy on 11/6/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit
import Firebase

class MessagesVC: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // User outlets
    
    var friendPhoto: String!
    var friendName: String!
    var friendId: String!
    var friendEmail: String!
    
    // Message Outlets
    let sender = CurrentUserInformation.uid!
    var messages: [Message] = []
    var selectedImage: UIImage!
    
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
        tableView.register(UINib(nibName: "CurrentUsrMediaMessageCell", bundle: nil), forCellReuseIdentifier: "CurrentUsrMediaMessageCell")
        tableView.register(UINib(nibName: "FriendMediaMessageCell", bundle: nil), forCellReuseIdentifier: "FriendMediaMessageCell")
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
        if let message = messageTextfield.text {
            sendMessagesHandler(message)
        }
        messageTextfield.resignFirstResponder()
    }
    
    func sendMessagesHandler(_ message: String){
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
            let userMessagesRef = Constants.FirebaseDB.db.reference().child("friend-messages").child(self.sender).child(friendId)
            let messageId = childRef.key!
            userMessagesRef.updateChildValues([messageId: 1])
            
            let friendRef = Constants.FirebaseDB.db.reference().child("friend-messages").child(friendId).child(self.sender)
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
                message.mediaUrl = values["mediaUrl"] as? String
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            selectedImage = editedImage
        }else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImage = image
        }
        if let image = selectedImage {
            uploadImageToFirebase(image)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func uploadImageToFirebase(_ image: UIImage){
        let mediaName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("message-img").child(mediaName)
        if let jpegImage = self.selectedImage?.jpegData(compressionQuality: 0.1) {
            
            storageRef.putData(jpegImage, metadata: nil) { (metadata, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                storageRef.downloadURL { (url, error) in
                    guard let url = url else { return }
                    self.sendMediaMessage(url.absoluteString)
                }
            }
            
        }
    }
    
    func sendMediaMessage(_ mediaUrl: String){
        guard let friendId = friendId else { return }
        
        let values = ["mediaUrl": mediaUrl, "sender": self.sender, "date": Date().timeIntervalSince1970, "friend": friendId] as [String : Any]
        let reference = Constants.FirebaseDB.db.reference().child("messages")
        let childRef = reference.childByAutoId()
        childRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                print("error")
                return
            }
            let userMessagesRef = Constants.FirebaseDB.db.reference().child("friend-messages").child(self.sender).child(friendId)
            let messageId = childRef.key!
            userMessagesRef.updateChildValues([messageId: 1])
            
            let friendRef = Constants.FirebaseDB.db.reference().child("friend-messages").child(friendId).child(self.sender)
            friendRef.updateChildValues([messageId: 1])
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func openImagePicker(_ type: UIImagePickerController.SourceType){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = type
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func photoLibraryPressed(_ sender: Any) {
        openImagePicker(.photoLibrary)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if self.messageTextfield.text?.count == 0 { return false }
        if let message = messageTextfield.text{
            sendMessagesHandler(message)
        }
        messageTextfield.resignFirstResponder()
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
            if message.mediaUrl == nil {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SenderMessagesCell") as! SenderMessagesCell
                cell.messagesLabel.text = message.message
                cell.timeLabel.text = dateFormatter.string(from: date as Date)
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "CurrentUsrMediaMessageCell") as! CurrentUsrMediaMessageCell
                cell.mediaMessage.loadImageCacheWithUrlString(imageUrl: message.mediaUrl)
                cell.timeLabel.text = dateFormatter.string(from: date as Date)
                return cell
            }
            
        }else{
            if message.mediaUrl == nil {
                let cell = tableView.dequeueReusableCell(withIdentifier: "FriendMessagesCell") as! FriendMessagesCell
                getSenderInfo(sender: message.sender) { (data, error) in
                    guard let data = data else { return }
                    cell.profileImage.loadImageCacheWithUrlString(imageUrl: data["profileImage"] as! String)
                }
                cell.messageLabel.text = message.message
                cell.timeLabel.text = dateFormatter.string(from: date as Date)
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "FriendMediaMessageCell") as! FriendMediaMessageCell
                cell.mediaMessage.loadImageCacheWithUrlString(imageUrl: message.mediaUrl)
                cell.timeLabel.text = dateFormatter.string(from: date as Date)
                return cell
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}
