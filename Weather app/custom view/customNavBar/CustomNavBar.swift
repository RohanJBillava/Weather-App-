//
//  CustomNavBar.swift
//  Weather app
//
//  Created by Rohan J Billava on 23/02/22.
//


import UIKit

 class CustomNavBar: UINavigationItem {
    
    
    
     func createLeftNav() -> [UIBarButtonItem] {
        let button1 = UIButton.init(type: .custom)
        button1.setImage(#imageLiteral(resourceName: "logo"), for: .normal)
        
        button1.frame = CGRect(x: 0, y: 0, width: 113, height: 24)
        button1.isUserInteractionEnabled = false
        
        let LogobarButton = UIBarButtonItem(customView: button1)
        LogobarButton.accessibilityRespondsToUserInteraction = false
        
        
        
        
        let button2 = UIButton.init(type: .custom)
        
        button2.setImage(#imageLiteral(resourceName: "icon_menu_white"), for: .normal)
     
//        button2.addTarget(self, action: #selector(menuBarBtnItemTapped), for: .touchUpInside)
        
        button2.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        
        let menuBarBtnItem = UIBarButtonItem(customView: button2)
        
        let space = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        space.width = 30
        
//        UINavigationItem.leftBarButtonItems = [menuBarBtnItem,space, LogobarButton]
       return [menuBarBtnItem,space, LogobarButton]
    }
    
    @objc func menuBarBtnItemTapped(){
        print("tapped")
    }
}
