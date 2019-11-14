//
//  TextfieldVC.swift
//  Messenger
//
//  Created by Vitaliy Paliy on 11/2/19.
//  Copyright © 2019 PALIY. All rights reserved.
//


import UIKit

@IBDesignable class TextFieldVC: UITextField, UITextFieldDelegate {
    
    let border = CALayer()
        
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
    
    @IBInspectable open var lineColor : UIColor = UIColor.black {
        didSet{
            border.borderColor = lineColor.cgColor
        }
    }
    
    @IBInspectable open var selectedLineColor : UIColor = UIColor.black {
        didSet{
        }
    }
    
    let padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    
    @IBInspectable var moveTextBy: Double = 0{
        didSet{
            let paddingView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: moveTextBy, height: 2.0))
            leftView = paddingView
            leftViewMode = .always
        }
    }
    
    required init?(coder aDecoder: (NSCoder?)) {
        super.init(coder: aDecoder!)
        self.delegate=self;
        border.borderColor = lineColor.cgColor
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "",
                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        
        border.frame = CGRect(x: 0, y: self.frame.size.height - lineHeight, width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = lineHeight
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
    override func draw(_ rect: CGRect) {
        border.frame = CGRect(x: 0, y: self.frame.size.height - lineHeight, width:  self.frame.size.width, height: self.frame.size.height)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        border.frame = CGRect(x: 0, y: self.frame.size.height - lineHeight, width:  self.frame.size.width, height: self.frame.size.height)
        self.delegate = self
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        border.borderColor = selectedLineColor.cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        border.borderColor = lineColor.cgColor
    }
    
    @IBInspectable open var lineHeight : CGFloat = CGFloat(1.0) {
        didSet{
            border.frame = CGRect(x: 0, y: self.frame.size.height - lineHeight, width:  self.frame.size.width, height: self.frame.size.height)
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
            let imageView = UIImageView(frame: CGRect(x: leftPadding + 10, y: 0, width: 20, height: 20))
            imageView.image = image
            let width = leftPadding + 20
            let view = UIView(frame: CGRect(x: 0, y: 0, width: width + 15, height: 20))
            view.addSubview(imageView)
            leftView = view
        }
        if let placeholder = placeholder{
            attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: tintColor ?? .gray])
        }

    }
}
