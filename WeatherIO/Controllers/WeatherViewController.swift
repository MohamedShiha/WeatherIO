//
//  WeatherViewController.swift
//  WeatherIO
//
//  Created by Mohamed Shiha on 8/19/19.
//  Copyright © 2019 Mohamed Shiha. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    // MARK: Outlets
    
    @IBOutlet weak var weatherScrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    // MARK: Variables
    
    var locationManager : CLLocationManager?
    var currentLocation : CLLocationCoordinate2D!
    
    let userDefaults = UserDefaults.standard
    
    var allLocations = [WeatherLocation]()
    var allForecastViews = [ForecastView]()
    var allWeatherData = [CityTempData]()
    
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startLocationManager()
        weatherScrollView.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if UserCongifuration.shouldRefresh {
            checkLocationAuth()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopLocationManager()
    }
    
    
    // MARK : Download weather data
    
    private func getWeather () {
        
        loadLocationsFromUserDefaults()
        createWeatherViews()
        addWeatherToScrollView()
        setPageControlPageNumber()
    }
    
    private func createWeatherViews () {
        for _ in 1..<allLocations.count {
            allForecastViews.append(ForecastView())
        }
    }
    
    private func jumpToForeCastView (index : Int) {
        
        let viewNumber = CGFloat(integerLiteral: index)
        let newOffset = CGPoint(x: (weatherScrollView.frame.width + 1.0) * viewNumber, y: 0)
        
        weatherScrollView.setContentOffset(newOffset, animated: true)
        updatePageControlSelectedPage(index)
    }
    
    private func addWeatherToScrollView () {
        
        for i in 1..<allLocations.count {
            
            var queryParameters = [
                WeatherBitClient.QueryParamterKeys.City : allLocations[i].city
            ]
            
            if UserCongifuration.loadTemperatureFormat(key: "TempFormat") == 1 {
                queryParameters[WeatherBitClient.QueryParamterKeys.Units] = "I"
            }
            
            setupForecastViws( queryParameters,i )
        }
    }
    
    private func setupForecastViws(_ queryParameters : [String:Any?],_ index : Int) {
        
        let forecastView = allForecastViews[index]
        
        getCurrentWeather(queryParameters ,forecastView)
        getDailyWeather(queryParameters ,forecastView)
        getWeeklytWeather(queryParameters ,forecastView)
        
        let xPos = self.view.frame.width * CGFloat(index)
        forecastView.frame = CGRect(x: xPos, y: 0, width: weatherScrollView.bounds.width, height: weatherScrollView.bounds.height)
        weatherScrollView.addSubview(forecastView)
        weatherScrollView.contentSize.width = forecastView.frame.width * CGFloat(index + 1)
    }
    
    private func getCurrentWeather (_ queryParameters : [String: Any?], _ forecastView : ForecastView) {
        
        forecastView.currentWeather = CurrentWeather()
        forecastView.currentWeather.getCurrentWeather(queryParameters) { (success) in
            forecastView.refreshData()
            self.generateWeatherList()
        }
    }
    
    private func getDailyWeather (_ queryParameters : [String: Any?], _ forecastView : ForecastView) {
        
        DailyForecast.downloadDailyForecastWeather(queryParameters) { (dailyForecast) in
            forecastView.dailyWeatherForecastData = dailyForecast
            forecastView.hourlyCollectionView.reloadData()
        }
    }
    
    private func getWeeklytWeather (_ queryParameters : [String: Any?], _ forecastView : ForecastView) {
        
        WeeklyForecast.downloadWeeklyForecastWeather(queryParameters) { (weeklyForecast) in
            forecastView.weeklyWeatherForecastData = weeklyForecast
            forecastView.tableView.reloadData()
        }
    }
    
    private func loadLocationsFromUserDefaults() {
        
        let currentLocation = WeatherLocation(city: "", country: "", countryCode: "", isCurrentLocation: true)

        allLocations = UserCongifuration.loadFromUserDefaults(key: "Locations")!
        allLocations.insert(currentLocation, at: 0)
    }
    
    
    // MARK : Page Control
    
    private func setPageControlPageNumber () {
        pageControl.numberOfPages = allForecastViews.count
    }
    
    private func updatePageControlSelectedPage(_ currentPage: Int) {
        pageControl.currentPage = currentPage
    }
    
    
    @IBAction func didSelectPage(_ sender: UIPageControl) {
        let selectedIndex = sender.currentPage
        jumpToForeCastView(index: selectedIndex)
    }
}

// MARK : Location Manager

extension WeatherViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location, ", error.localizedDescription)
    }
    
    private func startLocationManager() {
        
        if locationManager == nil {
            locationManager = CLLocationManager()
            locationManager!.desiredAccuracy = kCLLocationAccuracyBest
            locationManager!.requestWhenInUseAuthorization()
            locationManager!.delegate = self
        }
        
        locationManager?.startMonitoringSignificantLocationChanges()
    }
    
    private func stopLocationManager () {
        if locationManager != nil {
            locationManager!.stopMonitoringSignificantLocationChanges()
        }
    }
    
    func checkLocationAuth() {
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            currentLocation = locationManager!.location?.coordinate
        
            if currentLocation != nil {
                
                var parameters = [
                    WeatherBitClient.QueryParamterKeys.Latitude : String(currentLocation.latitude),
                    WeatherBitClient.QueryParamterKeys.Longitude : String(currentLocation.longitude)
                ]
                
                if UserCongifuration.loadTemperatureFormat(key: "TempFormat") == 1 {
                    parameters[WeatherBitClient.QueryParamterKeys.Units] = "I"
                }
                
                allForecastViews.insert(ForecastView(), at: 0)
                setupForecastViws(parameters,0)
                getCurrentWeather(parameters, allForecastViews[0])
                getDailyWeather(parameters, allForecastViews[0])
                getWeeklytWeather(parameters, allForecastViews[0])
                
                getWeather()
            } else {
                // Keep asking for location
                print("No location specified")
            }
        } else {
            locationManager?.requestWhenInUseAuthorization()
//            checkLocationAuth()
        }
    }
    
    private func generateWeatherList() {
        allWeatherData = []
        for forecastView in allForecastViews {
            allWeatherData.append(CityTempData(city: forecastView.currentWeather.city, temperature: forecastView.currentWeather.currentTemp))
        }
    }
    
    // Mark Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectedLocationsSegue" {
//            let navVC = segue.destination as! UINavigationController
//            let vc = navVC.viewControllers.first as! AllLocationsTableViewController
            let vc = segue.destination as! AllLocationsTableViewController
            vc.allWeatherData = allWeatherData
            vc.delegate = self
            vc.updaterDelegate = self
        }
    }
}


extension WeatherViewController : UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let value = scrollView.contentOffset.x / scrollView.frame.size.width
        updatePageControlSelectedPage(Int(round(value)))
    }
}


extension WeatherViewController : AllLocationsTableViewControllerDelegate {
    
    func didChooseLocation(index: Int, shouldRefresh: Bool) {
        
        if shouldRefresh {
            
            allLocations = []
            allWeatherData = []
            allForecastViews = []
            
            checkLocationAuth()
            
            UserCongifuration.shouldRefresh = false
        }
        
        jumpToForeCastView(index: index)
    }
}


extension WeatherViewController : TemperatureDataUpdaterDelegate {
  
    func updateAllTemperatureData() {
        
        allLocations = []
        allWeatherData = []
        allForecastViews = []
        
        checkLocationAuth()
        
        UserCongifuration.shouldRefresh = false
    }
}
