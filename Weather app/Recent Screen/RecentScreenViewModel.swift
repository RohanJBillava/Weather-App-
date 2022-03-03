//
//  RecentScreenViewModel.swift
//  Weather app
//
//  Created by Rohan J Billava on 28/02/22.
//

import Foundation
import UIKit

class  RecentScreenViewModel {
    var dataStore = DataStore()
    var recentlySearchedPlace: [String] = []
    
    var recentSearchArray: [FavouriteWeather] = [] {
        didSet {
            dataStore.save(recentArr: recentSearchArray)
            
            for weather in recentSearchArray {
                recentlySearchedPlace.append(weather.location)
            }
            
        }
    }
    
    init() {
        self.loadSavedRecentArrayFromDisk()
    }
    
    func add(weather: FavouriteWeather)  {
        recentSearchArray.append(weather)
    }
    
    func remove(weather: FavouriteWeather) {
        recentSearchArray.removeAll { (arr) -> Bool in
            if weather.location == arr.location {
                return true
            } else {
                return false
            }
        }
    }
    
    func removeSearch(at index: Int) {
        recentSearchArray.remove(at: index)
    }
    
    func clearSearchHistory() {
        recentSearchArray = []
    }
    
    func allSearches() -> [FavouriteWeather] {
        return recentSearchArray
    }
    
    func loadSavedRecentArrayFromDisk() {
        guard let path = dataStore.recentUrl?.path else {
            return
        }
        
        if FileManager.default.fileExists(atPath: path) {
            let recentArray = dataStore.loadRecentSearches()
            self.recentSearchArray = recentArray
        }else {
            print("file not exist")
        }
        
    }

}
