//
//  ChatsVC.swift
//  Messenger
//
//  Created by Vitaliy Paliy on 11/4/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit
import Firebase

class ChatsVC: UIViewController {
    
    var chats = [UserInformation]()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadChats()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        chats = []
    }
    
    override func viewDidAppear(_ animated: Bool) {
           super.viewDidAppear(animated)
           if chats.count > 0 {
               tableView.separatorInset.left = 100
               tableView.separatorColor = .black
           }
       }
    
    func loadChats(){
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
                    self.chats.append(user)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
}

extension ChatsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell") as! ChatCell
        let rec = Constants.Model.model
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        let chat = chats[indexPath.row]
        for i in 0..<rec.count{
            if rec[i].friend == chat.id || rec[i].sender == chat.id{
                guard let text = rec[i].message else { break }
                if text.count > 0 {
                    cell.lastMessageLabel.isHidden = false
                    cell.timeLabel.isHidden = false
                    cell.lastMessageLabel.text = text
                    let date = NSDate(timeIntervalSince1970: rec[i].time.doubleValue)
                    cell.timeLabel.text = "\(dateFormatter.string(from: date as Date))"
                }
            }
        }
        
        cell.nameLabel.text = chat.name
        if let url = chat.profileImage {
            cell.profileImage.loadImageCacheWithUrlString(imageUrl: url)
            cell.setNeedsLayout()
        }
        tableView.rowHeight = 100
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let friend = chats[indexPath.row]
        let controller = storyboard?.instantiateViewController(identifier: "MessagesVC") as! MessagesVC
        controller.friendId = friend.id
        controller.friendName = friend.name
        controller.friendPhoto = friend.profileImage
        controller.friendEmail = friend.email
        show(controller, sender: nil)
    }
    
}
