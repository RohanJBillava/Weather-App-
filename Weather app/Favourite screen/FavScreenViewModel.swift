//
//  FavScreenViewModel.swift
//  Weather app
//
//  Created by Rohan J Billava on 26/02/22.
//

import Foundation
import UIKit

class FavouriteWeather: NSObject, NSCoding {
    enum CodingKeys: String {
        case location = "location"
        case icon = "icon"
        case temperature = "temperature"
        case weatherDescription = "weatherDescription"
    }
    
    
   
    
    var location: String
    var icon: UIImage
    var temperature: String
    var weatherDescription: String
    
    init(location: String, icon: UIImage, temperature: String, weatherDescription: String) {
        self.location = location
        self.icon = icon
        self.temperature = temperature
        self.weatherDescription = weatherDescription
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(location, forKey: CodingKeys.location.rawValue)
        coder.encode(icon, forKey: CodingKeys.icon.rawValue)
        coder.encode(temperature, forKey: CodingKeys.temperature.rawValue)
        coder.encode(weatherDescription, forKey: CodingKeys.weatherDescription.rawValue)
        
    }
    
    required convenience init?(coder: NSCoder) {
        guard let loc = coder.decodeObject(forKey: CodingKeys.location.rawValue) as? String,
              let icon = coder.decodeObject(forKey: CodingKeys.icon.rawValue) as? UIImage,
              let temp = coder.decodeObject(forKey: CodingKeys.temperature.rawValue) as? String,
              let desc = coder.decodeObject(forKey: CodingKeys.weatherDescription.rawValue) as? String else {
            return nil
        }
        self.init(location: loc, icon: icon, temperature: temp, weatherDescription: desc)
    }
    
    
}


class FavScreenViewModel {
    var dataStore = DataStore()
    var favouritesArray:[FavouriteWeather] = [] {
        didSet {
            dataStore.save(favouritesArr: favouritesArray)
        }
    }
    
    
    init() {
        self.loadSavedFavouritesArrayFromDisk()
    }
    
    func add(weather: FavouriteWeather)  {
        favouritesArray.append(weather)
    }
    
    func remove(weather: FavouriteWeather) {
        favouritesArray.removeAll { (arr) -> Bool in
            if weather.location == arr.location {
                return true
            } else {
                return false
            }
        }
    }
    
    func removeAllFavourites() {
        favouritesArray = []
    }
    
    func allFavourites() -> [FavouriteWeather] {
        return favouritesArray
    }
    
    func loadSavedFavouritesArrayFromDisk() {
        guard let path = dataStore.url?.path else {
            return
        }
        
        if FileManager.default.fileExists(atPath: path) {
            let favArr = dataStore.loadFavourites()
            self.favouritesArray = favArr
        }else {
            print("file not exist")
        }
        
    }
}
