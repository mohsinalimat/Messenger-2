//
//  Message.swift
//  Messenger
//
//  Created by Vitaliy Paliy on 11/6/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import Foundation

class Message{
    var message: String!
    var sender: String!
    var time: NSNumber!
    var friend: String!
    var mediaUrl: String!
    func friendChecker() -> String {
        return sender == CurrentUserInformation.uid ? friend: sender
    }
}
