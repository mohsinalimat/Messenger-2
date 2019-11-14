//
//  TextfieldVC.swift
//  Messenger
//
//  Created by Vitaliy Paliy on 11/2/19.
//  Copyright © 2019 PALIY. All rights reserved.
//


import UIKit

@IBDesignable class TextFieldVC: UITextField {
    
    @IBInspectable var leftImage: UIImage? {
        didSet{
            updateView()
        }
    }
    
    @IBInspectable var leftPadding: CGFloat = 0 {
        didSet{
            updateView()
        }
    }

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet{
            layer.cornerRadius = cornerRadius
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
    
    func updateView(){
        
        if let image = leftImage {
            
            let imageView = UIImageView(frame: CGRect(x: leftPadding, y: 0, width: 20, height: 20))
            imageView.image = image
            leftViewMode = .always
            
            let width = leftPadding + 20
            
            let view = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 20))
            view.addSubview(imageView)
            
            leftView = view
            
        }else{
            leftViewMode = .never
        }
        if let placeholder = placeholder{
            attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: tintColor ?? .gray])
        }
        
    }
}
