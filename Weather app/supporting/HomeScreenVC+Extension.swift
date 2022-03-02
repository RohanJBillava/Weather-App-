//
//  HomeScreenVC+Extension.swift
//  Weather app
//
//  Created by Rohan J Billava on 01/03/22.
//

import Foundation
import UIKit

public struct segueIdentifier {
    let favoutire = "toFavourite"
    let recent = "toRecent"
}


extension HomeScreenViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchbar(shouldShow: false)
        setupLeftNavBar()
        bgViewBottomConstraint.constant = view.frame.size.height
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
            if let searchText = searchBar.text {
                if  let url: URL = .getURLForCityName(q: searchText) {
                    self.networkManager.getWeatherDetailsForCity(url: url) { (data, sucess) in
                        if sucess {
                            print(sucess)
                            if let data = data {
                                guard let weatherData = self.parser.parse(data: data) else {
                                    return
                                }
                                let weather = self.parser.convertDataToModel(data: weatherData)

                                self.wmvm.add(weather: weather)
                                
                                self.updateUI(for: weather.name)
                        
                                DispatchQueue.main.sync {
                                    searchBar.text = ""
                                }
                                
                            }

                        }else {
                            DispatchQueue.main.async {
                                searchBar.text = ""
                                self.showAlert(title: "Invalid City", message: "please enter city name properly")
                            }
                        }
                    }
                }else {
                    searchBar.text = ""
                    self.showAlert(title: "Invalid City", message: "please enter city name properly")

                }
            }
 
//        mygroup.notify(queue: .main) {
//            self.saveSearchedPlace()
//        }
    }


}

extension UINavigationBar {
    func transparentNavigationBar() {
    self.setBackgroundImage(UIImage(), for: .default)
    self.shadowImage = UIImage()
    self.isTranslucent = true
    }
}

extension UIViewController {
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "ok", style: .cancel) { (ok) in
            self.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
}
