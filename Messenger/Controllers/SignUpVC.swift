//
//  SignUpVC.swift
//  Messenger
//
//  Created by Vitaliy Paliy on 11/3/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController {

    @IBOutlet weak var backButton: ButtonVC!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    

    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)  
    }
    
}
