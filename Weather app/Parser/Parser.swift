//
//  Parser.swift
//  Weather app
//
//  Created by Rohan J Billava on 23/02/22.
//

import Foundation



class Parser {
    
    typealias mainType = (temp:Double,feels_like: Double, temp_min:Double,temp_max:Double,pressure:Double,humidity:Double)
    typealias weatherType = (icon: String, description: String)
    
    func parse(data: Data) -> [String:Any]? {
        
        do {
            let json =
            try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
            
                return json
            
        } catch  {
            print(error)
        }
        return nil
    }
    
    func convertDataToModel(data: [String:Any]) -> WeatherModel {
        let country = getSysFrom(data: data)
        let main = fetchMainFrom(data: data)
        let weather = fetchWeatherFrom(data: data)
        
        if  let name = data["name"] as? String,
            let dt = data["dt"] as? TimeInterval,
            let main = main,
            let weather = weather {
            return WeatherModel(name: name, dt: dt, temperature: main.temp, minTemperature: main.temp_min, maxTemperature: main.temp_max,humidity: main.humidity, weather: weather, country: country)
        }else {
            fatalError("got nil while unwrapping optionals")
        }
        
    }
    
    func fetchWeatherFrom(data: [String:Any]) -> weatherType? {
        let weatherDetailsArr = data["weather"] as? [[String:Any]]
        guard let weatherDetails = weatherDetailsArr?.first,
              let icon = weatherDetails["icon"] as? String,
              let desc = weatherDetails["description"] as? String else {
            return nil
        }
        
        return (icon, desc)
    }
    
    func getSysFrom(data: [String:Any]) -> String {
        let sys = data["sys"] as? [String:Any]
        guard let country = sys?["country"] as? String else {
            return "nil"
        }
        // hard coded for temporary use
        if country == "IN" {
            return "India"
        }else {
            return country
        }
    }
    
    func fetchMainFrom(data: [String:Any]) -> mainType? {
        let res:mainType
        guard let main = data["main"] as? [String:Any] else {
            return nil
        }
        
        guard let temp = main["temp"] as? Double,
              let feelsLike = main["feels_like"] as? Double,
              let minTemp = main["temp_min"] as? Double,
              let maxTemp = main["temp_max"] as? Double,
              let pressure = main["pressure"] as? Double,
              let humidity = main["humidity"] as? Double else {
            return nil
        }
        res = (temp,feelsLike,minTemp,maxTemp,pressure,humidity)
        return res
    }
}
