//
//  DataStore.swift
//  Weather app
//
//  Created by Rohan J Billava on 26/02/22.
//

import Foundation


class DataStore {
    
    let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Favourites List")
    let recentUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Recent List")
    
    func save(favouritesArr: [FavouriteWeather])  {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: favouritesArr, requiringSecureCoding: false)
            guard let url = url else {return}
            print(url)
            try data.write(to: url)
        }catch{
            print("ERROR: \(error.localizedDescription)")
        }
    }
    
    func loadFavourites() -> [FavouriteWeather] {
        guard let url = url else {return []}
        do {
            let data = try Data(contentsOf: url)
            if let weather = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [FavouriteWeather] {
//                print(weather)
                return weather
            }else {
                return []
            }
        }catch {
            print("ERROR\(error.localizedDescription)")
            return []
        }
    }
    
    func save(recentArr: [FavouriteWeather])  {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: recentArr, requiringSecureCoding: false)
            guard let url = recentUrl else {return}
            print(url)
            try data.write(to: url)
        }catch{
            print("ERROR: \(error.localizedDescription)")
        }
    }
    
    
  
    
    func loadRecentSearches() -> [FavouriteWeather] {
        guard let url = recentUrl else {return []}
        do {
            let data = try Data(contentsOf: url)
            if let weather = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [FavouriteWeather] {
//                print(weather)
                return weather
            }else {
                return []
            }
        }catch {
            print("ERROR\(error.localizedDescription)")
            return []
        }
    }
    
}
