//
//  ForecastView.swift
//  WeatherIO
//
//  Created by Mohamed Shiha on 8/19/19.
//  Copyright © 2019 Mohamed Shiha. All rights reserved.
//

import UIKit

class ForecastView: UIView {
    
    
    // MARK : Outlets
    
    @IBOutlet var mainView: UIView!
    
//    @IBOutlet weak var weatherInfoView: UIView!
    @IBOutlet weak var weatherInfoView: GradientView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherInfoLabel: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var bottomContainer: UIView!
    
    @IBOutlet weak var hourlyCollectionView: UICollectionView!
    @IBOutlet weak var infoCollectionView: UICollectionView!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK : Variables
    
    var currentWeather : CurrentWeather!
    var weeklyWeatherForecastData = [WeeklyForecast]()
    var dailyWeatherForecastData = [DailyForecast]()
    var weatherInfoData = [WeatherInfo]()
    
    // MARK : Initialisers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        mainInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        mainInit()
    }
    
    private func mainInit () {
        
        Bundle.main.loadNibNamed("ForecastView", owner: self, options: nil)
        addSubview(mainView)
        mainView.frame = self.bounds
        mainView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        setupTableView()
        setupHourlyCollectionView()
        setupInfoCollectionView()
    }
    
    private func setupTableView () {
        
        tableView.register(UINib(nibName: "WeatherTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "cell")
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
    
    private func setupHourlyCollectionView () {
        
        hourlyCollectionView.register(UINib(nibName: "ForecastCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "cell")
        
        hourlyCollectionView.dataSource = self
    }
    
    private func setupInfoCollectionView () {
        
        infoCollectionView.register(UINib(nibName: "InfoCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "cell")
        
        infoCollectionView.dataSource = self
    }
    
    func refreshData () {
        setupCurrentWeather()
        setupWeatherInfo()
        infoCollectionView.reloadData()
    }
    
    private func setupInfoViewBasedOnTime() {
        
        let currentTime = extractDate(from: extractTimeString(from: currentWeather.datetime))
        let sunriseTime = extractDate(from: currentWeather.sunrise)
        let sunsetTime = extractDate(from: currentWeather.sunset)
        
        if let sunriseTime = sunriseTime, let sunsetTime = sunsetTime, let currentTime = currentTime {
            
            if currentTime.time < sunriseTime.time || ( currentTime.time > sunriseTime.time && currentTime.time > sunsetTime.time) {
                
                setupNightWeatherUI()
                
            } else if currentTime.time > sunriseTime.time && currentTime.time < sunsetTime.time {
                
                setupMorningWeatherUI()
                
            } else {
                weatherInfoView.backgroundColor = UIColor.white
            }
        } else {
            print("Failed to get sunrise and sunset time")
        }
    }

    func setupNightWeatherUI () {
        
        weatherInfoView.firstColor = UIColor(red: 52 / 255, green: 152 / 255, blue: 219 / 255, alpha: 0.6)
        weatherInfoView.secondColor = UIColor(red: 48 / 255, green: 107 / 255, blue: 150 / 255, alpha: 0.6)
        weatherInfoView.thirdColor = UIColor(red: 44 / 255, green: 62 / 255, blue: 80 / 255, alpha: 0.6)
        
        cityNameLabel.textColor = UIColor.white
        dateLabel.textColor = UIColor.white
        temperatureLabel.textColor = UIColor.white
        weatherInfoLabel.textColor = UIColor.white
    }
    
    func setupMorningWeatherUI () {
        
        weatherInfoView.firstColor = UIColor(red: 244 / 255, green: 107 / 255, blue: 69 / 255, alpha: 0.6)
        weatherInfoView.secondColor = UIColor(red: 241 / 255, green: 137 / 255, blue: 71 / 255, alpha: 0.6)
        weatherInfoView.thirdColor = UIColor(red: 238 / 255, green: 168 / 255, blue: 73 / 255, alpha: 0.6)
        
        cityNameLabel.textColor = UIColor.darkGray
        dateLabel.textColor = UIColor.darkGray
        temperatureLabel.textColor = UIColor.darkGray
        weatherInfoLabel.textColor = UIColor.darkGray
    }
    
    
    // MARK : Setup UI
    
    private func setupCurrentWeather () {
        
        cityNameLabel.text = currentWeather.city
        dateLabel.text = "Today, \(currentWeather.date.shortenDate())"
        weatherInfoLabel.text = currentWeather.weatherType
        temperatureLabel.text = String(format: "%.0f%@", currentWeather.currentTemp, getTemperatureFormatString())
        print(currentWeather.date)
        print(currentWeather.datetime)
        setupInfoViewBasedOnTime()
    }
    
    private func setupWeatherInfo () {
        
        let windSpeed = WeatherInfo(info: String(format: "%.1f m/sec", currentWeather.windSpeed), name: nil, image: #imageLiteral(resourceName: "wind"))
        let humidity = WeatherInfo(info: String(format: "%.0f ", currentWeather.humidity), name: nil, image: #imageLiteral(resourceName: "humidity"))
        let pressure = WeatherInfo(info: String(format: "%.0f mb", currentWeather.pressure), name: nil, image: #imageLiteral(resourceName: "pressure"))
        let visibility = WeatherInfo(info: String(format: "%.0f km", currentWeather.visibility), name: nil, image: #imageLiteral(resourceName: "visibility"))
        let feelsLike = WeatherInfo(info: String(format: "%.1f", currentWeather.feelsLike), name: nil, image: #imageLiteral(resourceName: "feelsLike"))
        let uvIndex = WeatherInfo(info: String(format: "%.1f", currentWeather.uv), name: "UV Index", image: nil)
        let sunrise = WeatherInfo(info: currentWeather.sunrise, name: nil, image: #imageLiteral(resourceName: "sunrise"))
        let sunset = WeatherInfo(info: currentWeather.sunset, name: nil, image: #imageLiteral(resourceName: "sunset"))
        
        weatherInfoData = [ windSpeed, humidity, pressure, visibility, feelsLike, uvIndex, sunrise, sunset ]
    }
}


// MARK : TableView Stubs

extension ForecastView : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weeklyWeatherForecastData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! WeatherTableViewCell
        cell.generateCell(weeklyWeatherForecastData[indexPath.row])
        
        return cell
    }
}


// MARK : CollectionView Stubs

extension ForecastView : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == hourlyCollectionView {
            return dailyWeatherForecastData.count
        } else {
            return weatherInfoData.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == hourlyCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ForecastCollectionViewCell
            cell.generateCell(dailyWeatherForecastData[indexPath.row])
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! InfoCollectionViewCell
            cell.generateCell(weatherInfo: weatherInfoData[indexPath.row])
            
            return cell
        }
    }
}
