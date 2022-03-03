//
//  FavouriteScreenViewController.swift
//  Weather app
//
//  Created by Rohan J Billava on 25/02/22.
//

import UIKit



class FavouriteScreenViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var favouriteCount: robotoRegularFontLabel!
    
    var searchBar = UISearchBar()
    var favScreenVm: FavScreenViewModel?
    var favouritesArray:[FavouriteWeather] = [] {
        didSet {
            favouriteCount.text = "\(favouritesArray.count) City added as favourite"
            filteredData = favouritesArray
        }
    }
    
    var filteredData:[FavouriteWeather] = []
    let customNavBar = CustomNavBar()
    
    //
    // MARK: VIEW METHODS
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createRightBarButtonItem()
        tableView.backgroundColor = .none
        configNavigationController()
        configSearchBar()
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
    

    func configNavigationController() {
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .black
    }
    
    func configSearchBar() {
        searchBar.sizeToFit()
        searchBar.delegate = self
    }
    
    // MARK: RIGHT NAV BAR ITEMS
    func createRightBarButtonItem() {
        
        let searchBarItem = customNavBar.createRightBarButtons()
        searchBarItem.action = #selector(searchBtnTapped)
        searchBarItem.target = self
        searchBarItem.tintColor = .black
        navigationItem.rightBarButtonItem = searchBarItem
    }

    @objc func searchBtnTapped() {
        navigationItem.titleView = searchBar
        navigationItem.rightBarButtonItem = nil
        searchBar.showsCancelButton = true
        searchBar.becomeFirstResponder()
        
    }
    
    @IBAction func removeAllBtnTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "", message: "Are you sure want to remove all the favourites?", preferredStyle: .alert)
        let no = UIAlertAction(title: "No", style: .cancel) { (no) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(no)
        let yes = UIAlertAction(title: "Yes", style: .destructive) { (ok) in
            if let favScreenVm = self.favScreenVm {
                self.favScreenVm?.removeAllFavourites()
                self.favouritesArray = favScreenVm.allFavourites()
                self.tableView.reloadData()
                alert.dismiss(animated: true, completion: nil)
            }
            
        }
        alert.addAction(yes)
        present(alert, animated: true, completion: nil)
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
        filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let weather = filteredData[indexPath.row]
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
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            favouritesArray.remove(at: indexPath.row)
            favScreenVm?.removeFavourite(at: indexPath.row)
            if let favScreenVm = favScreenVm {
                favouritesArray = favScreenVm.allFavourites()
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
}

extension FavouriteScreenViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navigationItem.titleView = nil
        searchBar.showsCancelButton = false
        searchBar.text = ""
        self.createRightBarButtonItem()
        filteredData = favouritesArray
        tableView.reloadData()
    }
    
//    func extractLocation(from text: String) -> String.SubSequence? {
//        guard  let indexOfComma = text.firstIndex(of: ",") else {
//            return nil
//        }
//        let start = text.startIndex
//        let end = text.index(before: indexOfComma)
//        let range = start...end
//        let str = text[range]
//
//        return str
//
//    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = favouritesArray.filter { (item) -> Bool in
            
            if searchText == "" {
                return true
            }else if item.location.lowercased().contains(searchText.lowercased()) {
                return true
            }else {
                return false
            }
            
        }
        tableView.reloadData()
        
    }
    
}
