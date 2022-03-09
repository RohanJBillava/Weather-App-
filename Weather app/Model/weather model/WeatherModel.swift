//
//  WeatherModel.swift
//  Weather app
//
//  Created by Rohan J Billava on 23/02/22.
//

import UIKit

class WeatherModel {
  
    var weather: weatherType
    var name: String
    var dt: TimeInterval
    var temperature: Double
    var minTemperature: Double
    var maxTemperature: Double
    var humidity: Double
    var country: String//n
    
    init(name: String, dt: TimeInterval, temperature: Double, minTemperature: Double, maxTemperature: Double, humidity: Double,weather: weatherType, country: String) {
        self.name = name
        self.dt = dt
        self.temperature = temperature
        self.minTemperature = minTemperature
        self.maxTemperature = maxTemperature
        self.humidity = humidity
        self.weather = weather
        self.country = country
    }
   
    
    func homeWeatherRepresentation() -> HomeWeather {
        return HomeWeather(name: self.name, dt: self.dt, temperature: self.temperature, minTemperature: self.minTemperature, maxTemperature: self.maxTemperature, humidity: self.humidity, weather: self.weather, country: self.country)
    }
}
