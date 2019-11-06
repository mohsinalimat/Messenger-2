//
//  MessagesCell.swift
//  Messenger
//
//  Created by Vitaliy Paliy on 11/6/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit

class MessagesCell: UITableViewCell {

    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var userImage: ImageVC!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
