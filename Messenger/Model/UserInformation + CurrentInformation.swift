//
//  UserInformation Model.swift
//  Messenger
//
//  Created by Vitaliy Paliy on 11/5/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import Foundation

class UserInformation{
    var id: String?
    var name: String?
    var email: String?
    var profileImage: String?
}

class CurrentUserInformation{
    static var name: String!
    static var email: String!
    static var profileImage: String!
}
