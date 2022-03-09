//
//  CustomNavBar.swift
//  Weather app
//
//  Created by Rohan J Billava on 23/02/22.
//


import UIKit

 class CustomNavBar: UINavigationItem {
    
    
    
     func createLeftBarButtons() -> [UIBarButtonItem] {
        let button1 = UIButton.init(type: .custom)
        button1.setImage(#imageLiteral(resourceName: "logo"), for: .normal)
        
        button1.frame = CGRect(x: 0, y: 0, width: 113, height: 24)
        button1.isUserInteractionEnabled = true
        
        let LogobarButton = UIBarButtonItem(customView: button1)
        LogobarButton.accessibilityRespondsToUserInteraction = false
        
        
        
        
        let button2 = UIButton.init(type: .custom)
        
        button2.setImage(#imageLiteral(resourceName: "icon_menu_white"), for: .normal)
        
        button2.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        
        let menuBarBtnItem = UIBarButtonItem(customView: button2)
        
        let space = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        space.width = 30
        
       return [menuBarBtnItem,space, LogobarButton]
    }
    
    func createRightBarButtons() -> UIBarButtonItem {
        let searchBtn = UIBarButtonItem(barButtonSystemItem: .search, target: nil, action: nil)
        searchBtn.tintColor = .white
        return searchBtn
    }
}
