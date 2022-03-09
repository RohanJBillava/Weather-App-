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
        searchBgView.removeFromSuperview()
//        filteredRecentSearches = recentSearches
        searchBar.text = ""
//        searchBarTableView.reloadData()
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
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredRecentSearches = recentSearches.filter { (item) -> Bool in
            
            if searchText == "" {
                return true
            }else if item.lowercased().contains(searchText.lowercased()) {
                return true
            }else {
                return false
            }
            
        }
        searchBarTableView.reloadData()
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
    
    func showToast(message: String, x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, font: UIFont?, radius: CGFloat) {
        
        let toastLabel = UILabel(frame: CGRect(x:  x, y: y, width: width, height: height))
        toastLabel.textAlignment = .center
        toastLabel.font = font ?? UIFont.systemFont(ofSize: 16)
        toastLabel.numberOfLines = 0
        toastLabel.backgroundColor = #colorLiteral(red: 0.3179988265, green: 0.3179988265, blue: 0.3179988265, alpha: 0.4201359161)
        toastLabel.textColor = .white
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = radius
        toastLabel.clipsToBounds = true
        toastLabel.text = message
        self.view.addSubview(toastLabel)
        
        UIView.animate(withDuration: 1.0, delay: 1.0, options: .curveEaseInOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: { isCompleted in
            toastLabel.removeFromSuperview()
        }
        )
    }
}

