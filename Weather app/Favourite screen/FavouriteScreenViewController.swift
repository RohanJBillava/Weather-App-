//
//  FavouriteScreenViewController.swift
//  Weather app
//
//  Created by Rohan J Billava on 25/02/22.
//

import UIKit

class FavouriteScreenViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    
    
    var homeScreenVM: WeatherModelViewModel?
    var favScreenVm: FavScreenViewModel?
    var favouritesArray:[FavouriteWeather] = []
    //
    // MARK: VIEW METHODS
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createRightBarButtonItem()
        tableView.backgroundColor = .none
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .black
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if let favScreenVm = favScreenVm {
            self.favouritesArray = favScreenVm.allFavourites()
                tableView.reloadData()
           
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.navigationBar.backgroundColor = .none
        navigationController?.navigationBar.tintColor = .none
    }
    

    
    // MARK: RIGHT NAV BAR ITEMS
    func createRightBarButtonItem() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search,
                                                            target: self,
                                                            action: #selector(searchBtnTapped))
    }

    @objc func searchBtnTapped() {
        print("tap tap")
    }
    
}

//
// MARK: TABLEVIEW DELEGATES
//

extension FavouriteScreenViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favouritesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let weather = favouritesArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "favCell", for: indexPath) as! customFavouriteTableViewCell
        cell.configureFavWeather(weather: weather)
        cell.configureCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
