//
//  recentSCreenTableViewCell.swift
//  Weather app
//
//  Created by Rohan J Billava on 26/02/22.
//

import UIKit

class recentSCreenTableViewCell: UITableViewCell {

    
    @IBOutlet weak var tempDescription: robotoRegularFontLabel!
    @IBOutlet weak var temperature: robotoMediumLabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var location: robotoMediumLabel!
    @IBOutlet weak var subView: UIView!
    
    func configureCell() {
        contentView.backgroundColor = .clear
        subView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.1027664812)
        
    }
    
    func configureRecentWeather(weather: FavouriteWeather) {
        tempDescription.text = weather.weatherDescription
        temperature.text = "\(weather.temperature)°C"
        icon.image = weather.icon
        location.text = weather.location
    }

}
