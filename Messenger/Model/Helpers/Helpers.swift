//
//  Helpers.swift
//  Messenger
//
//  Created by Vitaliy Paliy on 11/3/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import Foundation
import UIKit


extension UIViewController {
    func showAlert(title: String, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alert, sender: nil)
    }
    
    func downloadImages(url: String, completion: @escaping (Data?, Error?) -> Void){
        
        let url = URL(string: url)
        if url == nil {
            print("error")
            return
        }
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            guard let data = data else {
                print("Error while trying to download images from Firebase.")
                completion(nil, error)
                return
            }
            completion(data, nil)
        }
        task.resume()
    }

}
