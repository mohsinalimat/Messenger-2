//
//  UserInfoTableViewCell.swift
//  Messenger
//
//  Created by Vitaliy Paliy on 11/4/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit

class UserInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userPhoto: ImageVC!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
        
    }

}
