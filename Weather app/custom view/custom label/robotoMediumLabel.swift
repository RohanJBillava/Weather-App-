//
//  robotoMediumLabel.swift
//  Weather app
//
//  Created by Rohan J Billava on 23/02/22.
//

import UIKit

@IBDesignable
class robotoMediumLabel: UILabel {

    @IBInspectable var fontsize:CGFloat = 18 {
        didSet {
            configureLabel()
        }
    }
    
    @IBInspectable var textcolor:UIColor = .white {
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
        font = UIFont(name: "Roboto-Medium", size: fontsize)
        textColor = textcolor
    }

}
