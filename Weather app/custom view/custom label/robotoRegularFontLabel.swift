//
//  robotoRegularFontLabel.swift
//  Weather app
//
//  Created by Rohan J Billava on 23/02/22.
//

import UIKit
@IBDesignable
class robotoRegularFontLabel: UILabel {

    @IBInspectable var fontsize:CGFloat = 13 {
        didSet {
            configureLabel()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLabel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureLabel()
    }
    
    override class func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
       
    }
    
    
    func configureLabel() {
        font = UIFont(name: "Roboto-Regular", size: fontsize)
        textColor = .white
    }
}
