//
//  FriendMediaMessageCell.swift
//  Messenger
//
//  Created by Vitaliy Paliy on 11/10/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit

class FriendMediaMessageCell: UITableViewCell {
    
    // Cell Outles
    @IBOutlet weak var mediaMessage: ImageVC!
    @IBOutlet weak var timeLabel: UILabel!
    
    // Outlets for mediaMessage
    var initialFrame: CGRect?
    var photoBackground: UIView?
    var slideUpImageView: UIImageView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mediaMessage.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(_:)))
        gesture.delegate = self
        mediaMessage.addGestureRecognizer(gesture)
    }
    
    @objc func imageTapped(_ sender: UITapGestureRecognizer){
        initialFrame = mediaMessage.superview?.convert(mediaMessage.frame, to: nil)
        slideUpImageView = UIImageView(frame: initialFrame!)
        slideUpImageView?.image = mediaMessage.image
        let slideGestureUp = UISwipeGestureRecognizer(target: self, action: #selector(self.zoomHandler(_:)))
        slideGestureUp.direction = .up
        let slideGestureDown = UISwipeGestureRecognizer(target: self, action: #selector(self.zoomHandler(_:)))
        slideGestureDown.direction = .down
        let photoWindow = UIApplication.shared.windows[0]
        photoBackground = UIView(frame: photoWindow.frame)
        buildPhotoBackground(true, alpha: 0, gesture: slideGestureUp, gesture2: slideGestureDown)
        photoWindow.addSubview(photoBackground!)
        let height = initialFrame!.height / initialFrame!.width * photoWindow.frame.width
        photoWindow.addSubview(slideUpImageView!)
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.slideUpImageView!.frame = CGRect(x: 0, y: 0, width: photoWindow.frame.width, height: height)
            self.slideUpImageView!.center = photoWindow.center
            self.photoBackground?.alpha = 1
        }, completion: nil)
        
    }
    
    @objc func zoomHandler(_ tap: UISwipeGestureRecognizer) {
        guard let slideImageView = tap.view else { return }
        slideUpImageView?.isHidden = true
        slideImageView.layer.cornerRadius = 20
        slideImageView.clipsToBounds = true
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            slideImageView.frame = self.initialFrame!
            self.buildPhotoBackground(false, alpha: 1)
        }) { (true) in
            slideImageView.removeFromSuperview()
        }
    }
    
    func buildPhotoBackground(_ buildStatus: Bool, alpha: CGFloat, gesture: UISwipeGestureRecognizer? = nil, gesture2: UISwipeGestureRecognizer? = nil){
        if buildStatus {
            photoBackground?.backgroundColor = .black
            photoBackground?.isUserInteractionEnabled = true
            photoBackground?.addGestureRecognizer(gesture!)
            photoBackground?.addGestureRecognizer(gesture2!)
        }else{
            photoBackground?.backgroundColor = .clear
        }
        photoBackground?.alpha = alpha
    }
    
    
}
