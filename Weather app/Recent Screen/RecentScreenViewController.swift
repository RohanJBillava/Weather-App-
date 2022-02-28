//
//  RecentScreenViewController.swift
//  Weather app
//
//  Created by Rohan J Billava on 25/02/22.
//

import UIKit

class RecentScreenViewController: UIViewController {

    
    
    @IBOutlet weak var table: UITableView!
    
    var homeScreenVM: WeatherModelViewModel?
    
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
    

}



//
// MARK: TABLEVIEW DELEGATES
//

extension RecentScreenViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "recentCell", for: indexPath) as! recentSCreenTableViewCell
        cell.configureCell()
        return cell
        
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
