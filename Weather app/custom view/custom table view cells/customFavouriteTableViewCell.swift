//
//  customFavouriteTableViewCell.swift
//  Weather app
//
//  Created by Rohan J Billava on 25/02/22.
//

import UIKit

class customFavouriteTableViewCell: UITableViewCell {

    @IBOutlet weak var temperatureDescLbl: robotoRegularFontLabel!
    @IBOutlet weak var temperatureLbl: robotoMediumLabel!
    
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var locationLabel: robotoMediumLabel!
    
    @IBOutlet weak var subView: UIView!
    
    func configureCell() {
        contentView.backgroundColor = .clear
        subView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.1027664812)
        
    }
    
    
    func configureFavWeather(weather: FavouriteWeather) {
        locationLabel.text = weather.location
        weatherIcon.image = weather.icon
        temperatureLbl.text = "\(weather.temperature)°C"
        temperatureDescLbl.text = weather.weatherDescription
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
