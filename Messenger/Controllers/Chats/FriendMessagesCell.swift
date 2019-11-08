//
//  FriendMessagesCell.swift
//  Messenger
//
//  Created by Vitaliy Paliy on 11/8/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit

class FriendMessagesCell: UITableViewCell {

    @IBOutlet weak var profileImage: ImageVC!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
