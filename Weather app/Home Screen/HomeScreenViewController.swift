//
//  HomeScreenViewController.swift
//  Weather app
//
//  Created by Rohan J Billava on 23/02/22.
//
import Foundation
import UIKit

struct segueIdentifier {
    let favoutire = "toFavourite"
    let recent = "toRecent"
}

class HomeScreenViewController: UIViewController {
    //
    // MARK: IB OUTLETS
    //
    
    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var celciusToFarenheitSwitch: UISegmentedControl!
    
    
    @IBOutlet weak var sideMenuLeadingConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var placeNameLabel: UILabel!
    
    @IBOutlet weak var dateLbl: UILabel!
    
  
    @IBOutlet weak var minMaxLbl: robotoMediumLabel!
    

    @IBOutlet weak var humidityLbl: robotoMediumLabel!
    

    @IBOutlet weak var tempDescriptionLbl: UILabel!
    
    @IBOutlet weak var weatherImage: UIImageView!
    
    @IBOutlet weak var favButton: UIButton!
    
    @IBOutlet weak var bgViewBottomConstraint: NSLayoutConstraint!
    
  
    
    
    //
    // MARK:CLASS PROPERTIES
    //
    
    let searchBar = UISearchBar()
    
    let wmvm = WeatherModelViewModel()
    let FavScreenVM = FavScreenViewModel()
    let recentScreenVM = RecentScreenViewModel()
    var weathers = [HomeWeather]()
    
    let locationManager = LocationManager.shared
    let networkManager = NetworkManager.shared
    let parser = Parser()
    var userDataFetchStatus = false {
        didSet {
            self.weathers = wmvm.fetchAllWeathersData()
            setUpHomeSCreenUsingWMVM()
        }
    }
    
    var customNavBar = CustomNavBar()
    var FavouriteBtnisOn: Bool = false
    let favBtnToggler = FavBtnToggler()
    let defaults = UserDefaults.standard
    //
    // MARK: OVERRIDING METHODS
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBottomView()
        setupLeftNavBar()
        configureCelciusToFarenheitSwitch()
        configSearchBar()
        self.FavouriteBtnisOn = getFavBtnStatus()
        fetchUserCurrentLocationAndData { (done) in
            if done {
                self.userDataFetchStatus = true
            }else {
                self.userDataFetchStatus = false
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        createRightBarButtonItem()
                
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let id = segueIdentifier()
        if segue.identifier == id.favoutire {
            let vc = segue.destination as? FavouriteScreenViewController
            vc?.delegate = self
            vc?.favScreenVm = FavScreenVM
            vc?.navigationItem.title = "Favourite"
            navigationItem.backButtonTitle = ""
        }
        
        if segue.identifier == id.recent {
            let vc = segue.destination as? RecentScreenViewController
            vc?.recentScreenVM = recentScreenVM
            vc?.navigationItem.title = "Recent Search"
            navigationItem.backButtonTitle = ""
        }
    }
    
    
    //
    // MARK: UI METHODS
    //
    
    func setUpHomeSCreenUsingWMVM() {
        guard let model = weathers.first else {
            return
        }
        let dt = model.dt
        let dateString = wmvm.fetchDateFrom(dt: dt)
        let minTemp = Int(model.minTemperature)
        let maxTemp = Int(model.maxTemperature)
        let temp = Int(model.temperature)
        let humidity = Int(model.humidity)
        let minMax = "\(minTemp)°-\(maxTemp)°"
        let description = model.weather.description.capitalized
        let iconID = model.weather.icon
        fetchImage(from: iconID)
        
        DispatchQueue.main.sync {
            placeNameLabel.text = "\(model.name), \(model.country)"
            dateLbl.text = dateString
            temperatureLabel.text = "\(temp)"
            minMaxLbl.text = minMax
            humidityLbl.text = "\(humidity)%"
            tempDescriptionLbl.text = description
        }
        
    }
    
    private func getFavBtnStatus() -> Bool {
        let status =  defaults.bool(forKey: "FavBtnStatus")
        if status {
            favBtnToggler.setButtonBackGround(view: favButton, onOffStatus: status)
        }else{
            favBtnToggler.setButtonBackGround(view: favButton, onOffStatus: status)
        }
        return status
    }
    
    private func configureBottomView() {
        bottomView.layer.borderWidth = 0.5
        bottomView.layer.borderColor = UIColor.white.cgColor
    }
    
    private func configureCelciusToFarenheitSwitch() {
        celciusToFarenheitSwitch.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.systemRed], for: .selected)
        celciusToFarenheitSwitch.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
    }
    
    private func setupLeftNavBar() {
        self.navigationItem.leftBarButtonItems = customNavBar.createLeftNav()
        navigationController?.navigationBar.transparentNavigationBar()
        navigationItem.leftBarButtonItems?.first?.customView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(menuBarBtnItemTapped)))
    }
    
    func animateSlideMenu() {
        UIView.animate(withDuration: 0.4) {
            self.view.layoutIfNeeded()
        }
    }
    
    func configSearchBar() {
        searchBar.sizeToFit()
        searchBar.backgroundColor = .systemGray5
        searchBar.delegate = self
    }
    
    func createRightBarButtonItem() {
        let searchBtn = UIBarButtonItem(barButtonSystemItem: .search,
                                        target: self,
                                        action: #selector(handleShowSearchBar))
        searchBtn.tintColor = .white
        navigationItem.rightBarButtonItem = searchBtn
    }
    
    func updateUI(for location: String) {
        let allWeathers = wmvm.fetchAllWeathersData()
        
        let res = allWeathers.filter { (item) -> Bool in
             item.name == location
        }
        
        if res.isEmpty {
            showAlert(title: "OOPS", message: "searched place not found")
        }else {
            guard let filteredWeather = res.first else {
                return
            }
            
            let dt = filteredWeather.dt
            let dateString = wmvm.fetchDateFrom(dt: dt)
            let minTemp = Int(filteredWeather.minTemperature)
            let maxTemp = Int(filteredWeather.maxTemperature)
            let temp = Int(filteredWeather.temperature)
            let humidity = Int(filteredWeather.humidity)
            let minMax = "\(minTemp)°-\(maxTemp)°"
            let description = filteredWeather.weather.description.capitalized
            let iconID = filteredWeather.weather.icon
            
             
            DispatchQueue.main.sync {
                fetchImage(from: iconID)
                searchbar(shouldShow: false)
                setupLeftNavBar()
                bgViewBottomConstraint.constant = view.frame.size.height
                placeNameLabel.text = "\(filteredWeather.name), \(filteredWeather.country)"
                dateLbl.text = dateString
                temperatureLabel.text = "\(temp)"
                minMaxLbl.text = minMax
                humidityLbl.text = "\(humidity)%"
                tempDescriptionLbl.text = description
                favBtnToggler.setButtonBackGround(view: favButton, onOffStatus: false)
                
//                guard let img = self.weatherImage.image else {
//                    print("unwrapping img failed")
//                    return
//                }
//                let searchedWeather = FavouriteWeather(location: filteredWeather.name, icon: img, temperature: "\(temp)", weatherDescription: description)
//                self.recentScreenVM.add(weather: searchedWeather)
            }
            
            
        }
        
    }
    
    
    //
    // MARK: DATA FETCHING
    //
    
    
    func fetchImage(from iconID: String)   {
      
        let imageAlreadyExists = wmvm.fetchWeatherImage(by: iconID)
        
        if imageAlreadyExists.sucess {
            DispatchQueue.main.async {
                self.weatherImage.image = imageAlreadyExists.img
            }
            
        }else{
            
            let url: URL = .URLforWeatherIcon(iconid: iconID)
//            print(url)
            
            networkManager.getImage(from: url) { (image) in
                self.wmvm.save(image: image, id: iconID)
                DispatchQueue.main.async {
                    self.weatherImage.image = image
                }
               
            }
        }
      
    }
    
   
    
    private func fetchUserCurrentLocationAndData(completion: @escaping ((Bool) -> Void) ) {
        locationManager.getUserLocation { (location) in
            let url:URL = .getURLForCurrentLocation(location: location)
            
            self.networkManager.getWeatherData(url: url) { (data) in
                print(data)
                let weatherData = self.parser.parse(data: data)
                
                guard weatherData != nil else {
                    print("weather data nil")
                    completion(false)
                    return
                }
                let weatherModel = self.parser.convertDataToModel(data: weatherData!)
                self.wmvm.add(weather: weatherModel)
                completion(true)
            }
        }

    }
    

    
    //
    // MARK: IB ACTIONS
    //
    @IBAction func slideMenuFavBtnTapped(_ sender: Any) {
//        let segueId = segueIdentifier()
        
    }
    
    @IBAction func slideMenuRecentsearchBtnTapped(_ sender: Any) {
    }
    
    @objc func handleShowSearchBar() {
        searchBar.becomeFirstResponder()
        navigationItem.leftBarButtonItems = nil
        bgViewBottomConstraint.constant = 0
        searchbar(shouldShow: true)
    }
    
    @IBAction func celciusToFarenheitTapped(_ sender: UISegmentedControl) {
        
        
        if  sender.selectedSegmentIndex == 0 {
            guard let f = temperatureLabel.text  else {
                return
            }
            if let fahrenheit = Double(f) {
                let res = convert(fahrenheit: fahrenheit)
                temperatureLabel.text = String(format: "%.0f", res)
            }

        }else if sender.selectedSegmentIndex == 1 {
            guard let c = temperatureLabel.text else {
                return
            }
            if let celcius = Double(c) {
                let res = convert(celcius:celcius )
                temperatureLabel.text = String(format: "%.0f", res)
            }

        
        }
    }
    

    @IBAction func homeButtonTapped(_ sender: Any) {
        sideMenuLeadingConstraint.constant = -270
        animateSlideMenu()
        DispatchQueue.main.asyncAfter(deadline: .now()+0.35) {
            self.navigationItem.leftBarButtonItems?.last?.customView?.isHidden = false
        }
        
        
    }

    @objc func menuBarBtnItemTapped(){
        sideMenuLeadingConstraint.constant = 0
        animateSlideMenu()
        navigationItem.leftBarButtonItems?.last?.customView?.isHidden = true
        
    }
    
    @IBAction func favBtnTapped(_ sender: UIButton) {
        
        FavouriteBtnisOn.toggle()
        guard let location = placeNameLabel.text,
        let icon = weatherImage.image,
        let temperature = temperatureLabel.text,
        let description = tempDescriptionLbl.text else {
            fatalError("error")
        }
        
        let weather = FavouriteWeather(location: location, icon: icon, temperature: temperature, weatherDescription: description)
        
        if FavouriteBtnisOn {
            FavScreenVM.add(weather: weather)
            defaults.setValue(FavouriteBtnisOn, forKey: "FavBtnStatus")
        }else {
            FavScreenVM.remove(weather: weather)
            defaults.setValue(FavouriteBtnisOn, forKey: "FavBtnStatus")
        }
          
        
        favBtnToggler.setButtonBackGround(view: sender, onOffStatus: FavouriteBtnisOn)
    }
    
    
    //
    // MARK: SUPPORTING FUNCTIONS
    //
    
    func convert(celcius: Double) -> Double {
        let f = (celcius * 1.8) + 32
        return f
    }
    func convert(fahrenheit: Double) -> Double {
        let celcius = (fahrenheit - 32) / 1.8
        return celcius
    }
    

    func searchbar(shouldShow: Bool) {
        showSearchBarButton(shouldShow: !shouldShow)
        searchBar.showsCancelButton = shouldShow
        if shouldShow {
            searchBar.tintColor = .black
            navigationItem.titleView = searchBar
        }else {
            navigationItem.titleView = nil
        }
    }
    
    func showSearchBarButton(shouldShow: Bool) {
        if shouldShow {
            createRightBarButtonItem()
        } else {
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    func saveSearchedPlace() {
        DispatchQueue.main.async {
            guard let location = self.placeNameLabel.text,
                  let icon = self.weatherImage.image,
                  let temperature = self.temperatureLabel.text,
                  let description = self.tempDescriptionLbl.text else {
                fatalError("error")
            }
            
            let weather = FavouriteWeather(location: location, icon: icon, temperature: temperature, weatherDescription: description)
            
            self.recentScreenVM.add(weather: weather)
        }
        
        
    }
    
}

//
//MARK: EXTENSIONS
//

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

extension HomeScreenViewController: UISearchBarDelegate {
   
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchbar(shouldShow: false)
        setupLeftNavBar()
        bgViewBottomConstraint.constant = view.frame.size.height
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            
            if  let url: URL = .getURLForCityName(q: searchText) {
                networkManager.getWeatherDetailsForCity(url: url) { (data, sucess) in
                    if sucess {
                        print(sucess)
                        if let data = data {
                            guard let weatherData = self.parser.parse(data: data) else {
                                return
                            }
                            let weather = self.parser.convertDataToModel(data: weatherData)
//                            print(weather)
                            
                            self.wmvm.add(weather: weather)
                            self.updateUI(for: weather.name)
                            
                            DispatchQueue.main.sync {
                                searchBar.text = ""
                            }
                            self.saveSearchedPlace()
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
                showAlert(title: "Invalid City", message: "please enter city name properly")
                
            }
            
            
        }
    }
    
   
}


extension HomeScreenViewController: FavouriteScreenViewControllerProtocol {
    func updateFavBtn(state: Bool) {
        FavouriteBtnisOn = state
        defaults.setValue(FavouriteBtnisOn, forKey: "FavBtnStatus")
        favBtnToggler.setButtonBackGround(view: favButton, onOffStatus: state)
    }
}
