//
//  slideMenuCustomButton.swift
//  Weather app
//
//  Created by Rohan J Billava on 23/02/22.
//

import UIKit
@IBDesignable
class slideMenuCustomButton: UIButton {

    @IBInspectable var fontsize:CGFloat = 14 {
        didSet {
            configureButton()
        }
    }
    
    @IBInspectable var lightGray:UIColor = UIColor(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1) {
        didSet {
            configureButton()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureButton()
    }
    
    override class func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
       
    }
    
    
    func configureButton() {
        titleLabel?.font = UIFont(name: "Roboto-Regular", size: fontsize)
        setTitleColor(lightGray, for: .normal)
    }

}
