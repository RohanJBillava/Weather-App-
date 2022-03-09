//
//  NetworkManager.swift
//  Weather app
//
//  Created by Rohan J Billava on 23/02/22.
//

import Foundation
import CoreLocation
import UIKit

extension URL {
    
    static func getURLForCurrentLocation(location: CLLocation) -> URL {
        let apiKey = "ddd5b4a946b6b1305abab17674003607"
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&units=metric&appid=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            fatalError("Invalid url")
        }
        return url
    }
    
    static func URLforWeatherIcon(iconid: String)  -> URL {
        let urlString = "https://openweathermap.org/img/wn/\(iconid)@2x.png"
        
        guard let url = URL(string: urlString) else {
            fatalError("Invalid url")
        }
        return url
    }
    
    static func getURLForCityName(q: String) -> URL? {
        let apiKey = "ddd5b4a946b6b1305abab17674003607"
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(q)&units=metric&appid=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            return nil
        }
        return url
    }
     
}




class NetworkManager {
    static let shared = NetworkManager()
    let session = URLSession.shared
    
    func getWeatherData(url: URL, completion: @escaping (_ data: Data) -> ())  {
        session.dataTask(with: url) { (data, response, error) in
            guard  error == nil else {
                fatalError("error in api call")
            }


            guard let response = response as? HTTPURLResponse,
                  response.statusCode == 200  else {
               fatalError("response error")
            }

            print(response.statusCode)


            guard let data = data else {
                fatalError("data error")
            }

           completion(data)
        }.resume()

    }
    
    func getWeatherDetailsForCity(url: URL, completion: @escaping (_ data: Data?, _ sucess: Bool) -> ()){
        
        session.dataTask(with: url) { (data, response, error) in
            if  error == nil {
                
                if let response = response as? HTTPURLResponse,
                   response.statusCode == 200 {
                    print(response.statusCode)
                    
                    if let data = data {
                        completion(data, true)
                    }else {
                        completion(nil,false)
                    }
                    
                }else {
                    completion(nil,false)
                }
            }else {
                completion(nil,false)
            }
        }.resume()
    }
    
    
    
    func getImage(from url: URL, completion: @escaping (_ image: UIImage) -> Void ) {
        session.dataTask(with: url) { (data, response, error) in
            guard  error == nil else {
                fatalError("error in api call")
            }


            guard let response = response as? HTTPURLResponse,
                  response.statusCode == 200  else {
               fatalError("response error")
            }
            print(response.statusCode)
            
            guard let data = data else {
                fatalError("data error")
            }
           
            if let image = UIImage(data: data) {
                completion(image)
            }
            
        }.resume()
    }
    
}
