//
//  recentSCreenTableViewCell.swift
//  Weather app
//
//  Created by Rohan J Billava on 26/02/22.
//

import UIKit

class recentSCreenTableViewCell: UITableViewCell {

    
    @IBOutlet weak var subView: UIView!
    
    func configureCell() {
        contentView.backgroundColor = .clear
        subView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.1027664812)
        
    }

}
