//
//  FavBtnToggler.swift
//  Weather app
//
//  Created by Rohan J Billava on 25/02/22.
//

import UIKit


class FavBtnToggler {
    func setButtonBackGround(view: UIButton,onOffStatus: Bool ) {
        
        let on = #imageLiteral(resourceName: "icon_favourite_active")
        let off = #imageLiteral(resourceName: "icon_favorite")
         switch onOffStatus {
              case true:

                   view.setImage(on, for: .normal)
//                    print("Button Pressed")
              
              default:
                view.setImage(off, for: .normal)
//                   print("Button Unpressed")
    }
    }
}



