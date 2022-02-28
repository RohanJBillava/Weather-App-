//
//  WeatherModelViewModel.swift
//  Weather app
//
//  Created by Rohan J Billava on 23/02/22.
//

import Foundation
import UIKit
typealias weatherType = (icon: String, description: String)

struct HomeWeather {
    var name: String
    var dt: TimeInterval
    var temperature: Double
    var minTemperature: Double
    var maxTemperature: Double
    var humidity: Double
    var weather: weatherType
    var country: String//n
}

class WeatherModelViewModel {
 
    var weathers: [WeatherModel] = [WeatherModel]()
    var weatherImages = [String:UIImage]()
  
    func add(weather: WeatherModel) {
        weathers.append(weather)
    }
    
    func fetchAllWeathersData() -> [HomeWeather] {
        var allWeather: [HomeWeather] = []
        for weather in weathers {
            let item = weather.homeWeatherRepresentation()
            allWeather.append(item)
        }
        return allWeather
    }
    
    func save(image: UIImage, id: String) {
        weatherImages.updateValue(image, forKey: id)
        print(weatherImages)
    }
    
    func fetchWeatherImage(by id: String) -> (img:UIImage?,sucess:Bool) {
        let img = weatherImages[id]
        return img != nil ? (img,true) : (nil,false)
    }
    
    func fetchDateFrom(dt: TimeInterval) -> String {
        let currentDate = Date()
        let format = DateFormatter()
        format.timeZone = TimeZone(secondsFromGMT: Int(dt))
        format.dateFormat = "E, dd MMM yyyy  HH:mm a"
        let dateString = format.string(from: currentDate)
        return dateString.uppercased()
    }
    
}
