//
//  FriendInfoVC.swift
//  Messenger
//
//  Created by Vitaliy Paliy on 11/13/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit

class FriendInfoVC: UIViewController {

    var friendImage: String!
    var friendName: String!
    var friendEmail: String!
    var isFriend: Bool!
    
    @IBOutlet weak var profileImage: ImageVC!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }
    
    func prepareUI() {
        profileImage.loadImageCacheWithUrlString(imageUrl: friendImage)
        nameLabel.text = friendName
        emailLabel.text = friendEmail
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
