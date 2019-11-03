//
//  BackgroundVC.swift
//  Messenger
//
//  Created by Vitaliy Paliy on 11/2/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit

@IBDesignable class BackgroundView: UIView {
    
    @IBInspectable var radius: CGFloat = 0{
        didSet{
            self.layer.cornerRadius = radius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0{
        didSet{
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
    
    @IBInspectable var shadowOpacity: Float = 1 {
        didSet{
            self.layer.shadowOpacity = shadowOpacity
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat = 0 {
        didSet{
            self.layer.shadowRadius = shadowRadius
        }
    }
    
    
    
    
    
}
