//
//  Helpers.swift
//  Messenger
//
//  Created by Vitaliy Paliy on 11/3/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit
import Firebase

// Caches the images
let imgCache = NSCache<AnyObject, AnyObject>()

// Helper methods for ViewControllers
extension UIViewController {
    
    func showAlert(title: String, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    func hideTabBar(status: Bool){
        tabBarController?.tabBar.isHidden = status
    }
    
    func hideNavBar(status: Bool){
        navigationController?.navigationBar.isHidden = status
    }
    
    func getSenderInfo(sender: String, completion: @escaping (_ data: [String: AnyObject]?, _ error: Error?) -> Void){
        let ref = Constants.FirebaseDB.db.reference().child("users").child(sender)
        ref.observeSingleEvent(of: .value) { (snapshot) in
            guard let data = snapshot.value as? [String: AnyObject] else { return }
            completion(data, nil)
        }
    }
    
}


extension UIImageView {
    func loadImageCacheWithUrlString(imageUrl: String){
        
        self.image = nil
        
        if let cachedImages = imgCache.object(forKey: imageUrl as NSString) as? UIImage{
            self.image = cachedImages
            return
        }
        let url = URL(string: imageUrl)
        if url == nil {
            print("error")
            return
        }
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            guard let data = data else {
                print("Error while trying to download images from Firebase.")
                return
            }
            DispatchQueue.main.async {
                if let downloadedImage = UIImage(data: data){
                    imgCache.setObject(downloadedImage, forKey: imageUrl as NSString)
                    self.image = downloadedImage
                }
            }
        }
        task.resume()
    }
}
