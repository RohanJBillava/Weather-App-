//
//  RecentScreenViewController.swift
//  Weather app
//
//  Created by Rohan J Billava on 25/02/22.
//

import UIKit

class RecentScreenViewController: UIViewController {

    
    
    @IBOutlet weak var table: UITableView!
    
    
    let customNavBar = CustomNavBar()
    var searchBar = UISearchBar()
    var recentScreenVM: RecentScreenViewModel?
    var recentsArr:[FavouriteWeather] = [] {
        didSet {
            filteredRecentsArr = recentsArr
        }
    }
    var filteredRecentsArr: [FavouriteWeather] = []
    
    //
    // MARK: VIEW METHODS
    //
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createRightBarButtonItem()
        table.backgroundColor = .none
        configNavigationController()
        configSearchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if let recentScreenVM = recentScreenVM {
            self.recentsArr = recentScreenVM.allSearches()
            table.reloadData()
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
    
    func createRightBarButtonItem() {
        
        let searchBarItem = customNavBar.createRightBarButtons()
        searchBarItem.action = #selector(searchBtnTapped)
        searchBarItem.target = self
        searchBarItem.tintColor = .black
        navigationItem.rightBarButtonItem = searchBarItem
    }
    
    
    
    @objc func searchBtnTapped() {
        searchBar.showsCancelButton = true
        navigationItem.rightBarButtonItem = nil
        searchBar.becomeFirstResponder()
        navigationItem.titleView = searchBar
    }
    
    @IBAction func clearBtnTapped(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "", message: "Are you sure want to remove all the favourites?", preferredStyle: .alert)
        let no = UIAlertAction(title: "No", style: .cancel) { (no) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(no)
        let yes = UIAlertAction(title: "Yes", style: .destructive) { (ok) in
            if let recentScreenVM = self.recentScreenVM {
                recentScreenVM.clearSearchHistory()
                self.recentsArr = recentScreenVM.allSearches()
                self.table.reloadData()
                
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

extension RecentScreenViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredRecentsArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let weather = filteredRecentsArr[indexPath.row]
        let cell = table.dequeueReusableCell(withIdentifier: "recentCell", for: indexPath) as! recentSCreenTableViewCell
        cell.configureRecentWeather(weather: weather)
        cell.configureCell()
        return cell
        
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
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
            guard let rsvm = recentScreenVM else {
                return
            }
            rsvm.removeSearch(at: indexPath.row)
            recentsArr.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
}


extension RecentScreenViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navigationItem.titleView = nil
        searchBar.showsCancelButton = false
        searchBar.text = ""
        self.createRightBarButtonItem()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredRecentsArr = recentsArr.filter { (item) -> Bool in
            
            if searchText == "" {
                return true
            }else if item.location.lowercased().contains(searchText.lowercased()) {
                return true
            }else {
                return false
            }
            
        }
        table.reloadData()
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
    }
    
    
}
