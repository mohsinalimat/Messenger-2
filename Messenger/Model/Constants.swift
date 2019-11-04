//
//  Constants.swift
//  Messenger
//
//  Created by Vitaliy Paliy on 11/3/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import Foundation
import Firebase
class Constants {
    struct Storyboard {
        static let signUpVC = "SignUpVC"
        static let signInVC = "SignInVC"
        static let controllersTabBar = "ControllersTabBar"
    }
    
    struct FirebaseDB {
        static let ref = Database.database().reference(fromURL: "https://messenger-9eb2f.firebaseio.com/")
    }
    
}
