//
//  Helpers.swift
//  Messenger
//
//  Created by Vitaliy Paliy on 11/3/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit

let imgCache = NSCache<AnyObject, AnyObject>()

extension UIViewController {
    
    func showAlert(title: String, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alert, sender: nil)
    }
    func hideTabBar(status: Bool){
        tabBarController?.tabBar.isHidden = status
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
