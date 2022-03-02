//
//  HomeScreenViewController.swift
//  Weather app
//
//  Created by Rohan J Billava on 23/02/22.
//
import Foundation
import UIKit



class HomeScreenViewController: UIViewController {
    
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
    // MARK:PROPERTIES
    //
    
    let searchBar = UISearchBar()
    let wmvm = WeatherModelViewModel()
    let FavScreenVM = FavScreenViewModel()
    let recentScreenVM = RecentScreenViewModel()
    var weathers = [HomeWeather]()
    let locationManager = LocationManager.shared
    let networkManager = NetworkManager.shared
    let parser = Parser()
    var customNavBar = CustomNavBar()
    var FavouriteBtnisOn = false
    let favBtnToggler = FavBtnToggler()
    let defaults = UserDefaults.standard
    let mygroup = DispatchGroup()
    
    var userDataFetchStatus = false {
        didSet {
            self.weathers = wmvm.fetchAllWeathersData()
            setUpHomeSCreenUsingWMVM()
        }
    }
    
    
    //
    // MARK: OVERRIDING METHODS
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBottomView()
        setupLeftNavBar()
        configureCelciusToFarenheitSwitch()
        configSearchBar()

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
        closeSlideMenu()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let id = segueIdentifier()
        if segue.identifier == id.favoutire {
            let vc = segue.destination as? FavouriteScreenViewController
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
    
    func closeSlideMenu() {
        sideMenuLeadingConstraint.constant = -270
        navigationItem.leftBarButtonItems?.last?.customView?.isHidden = false
    }
    
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

        fetchImage(from: iconID) { (img) in
            DispatchQueue.main.async {
                self.weatherImage.image = img
            }
            
        }
        
        
        DispatchQueue.main.sync {
            
            placeNameLabel.text = "\(model.name), \(model.country)"
            dateLbl.text = dateString
            temperatureLabel.text = "\(temp)"
            minMaxLbl.text = minMax
            humidityLbl.text = "\(humidity)%"
            tempDescriptionLbl.text = description
        }
        
    }
    
    
    
    private func configureBottomView() {
        bottomView.layer.borderWidth = 0.5
        bottomView.layer.borderColor = UIColor.white.cgColor
    }
    
    private func configureCelciusToFarenheitSwitch() {
        celciusToFarenheitSwitch.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.systemRed], for: .selected)
        celciusToFarenheitSwitch.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
    }
    
     func setupLeftNavBar() {
        self.navigationItem.leftBarButtonItems = customNavBar.createLeftBarButtons()
        navigationController?.navigationBar.transparentNavigationBar()
        navigationItem.leftBarButtonItems?.first?.customView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(menuBarBtnItemTapped)))
        navigationItem.leftBarButtonItems?.last?.customView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(weatherLogoTapped)))
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
        let searchBtn = customNavBar.createRightBarButtons()
        searchBtn.target = self
        searchBtn.action = #selector(handleShowSearchBar)
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
            fetchImage(from: iconID) { (img) in
                DispatchQueue.main.async {
                    self.weatherImage.image = img
                    self.saveSearchedPlace()
                }
            }
            
            
            DispatchQueue.main.sync {
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
            }
            
        }

    }
    
    
    //
    // MARK: DATA FETCHING
    //
    
    func fetchImage(from iconID: String, completion: @escaping ((_ img: UIImage) -> Void))  {
        let imageAlreadyExists = wmvm.fetchWeatherImage(by: iconID)
        
        if imageAlreadyExists.sucess {
            if let img = imageAlreadyExists.img {
                completion(img)
            }
        }else{
            
            let url: URL = .URLforWeatherIcon(iconid: iconID)
            
            networkManager.getImage(from: url) { (image) in
                self.wmvm.save(image: image, id: iconID)
                
                completion(image)
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
        
        
    }
    
    @IBAction func slideMenuRecentsearchBtnTapped(_ sender: Any) {
    }
    
    @objc func weatherLogoTapped() {
        showToast(message: "Refreshing \nplease wait", x: view.frame.width/2 - 100, y: self.view.frame.height - 150, width: 200, height: 100, font: UIFont(name: "Roboto-Medium", size: 20), radius: 28)
        
        fetchUserCurrentLocationAndData { (done) in
            if done {
                self.userDataFetchStatus = true
            }else {
                self.userDataFetchStatus = false
            }
        }
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
        favBtnToggler.setButtonBackGround(view: sender, onOffStatus: FavouriteBtnisOn)
        
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
    
    func saveSearchedPlace(){
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

