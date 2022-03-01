//
//  RecentScreenViewController.swift
//  Weather app
//
//  Created by Rohan J Billava on 25/02/22.
//

import UIKit

class RecentScreenViewController: UIViewController {

    
    
    @IBOutlet weak var table: UITableView!
    
    var recentScreenVM: RecentScreenViewModel?
    var recentsArr:[FavouriteWeather] = []
    //
    // MARK: VIEW METHODS
    //
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createRightBarButtonItem()
        table.backgroundColor = .none
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .black
        
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
    
    func createRightBarButtonItem() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search,
                                                            target: self,
                                                            action: #selector(searchBtnTapped))
    }
    
    @objc func searchBtnTapped() {
        print("tap tap")
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
        return recentsArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let weather = recentsArr[indexPath.row]
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
