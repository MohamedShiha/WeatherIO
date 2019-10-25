//
//  CurrentWeather.swift
//  WeatherIO
//
//  Created by Mohamed Shiha on 8/16/19.
//  Copyright © 2019 Mohamed Shiha. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class CurrentWeather {
    
    // MARK : Variables
    
    private var _city : String!
    private var _date : Date!
    private var _datetime : String!
    
    private var _currentTemp : Double!
    private var _feelsLike : Double!
    
    private var _weatherType : String!
    
    private var _sunrise : String!
    private var _sunset : String!
    
    private var _humidity : Double!
    private var _pressure : Double!
    private var _windSpeed : Double!
    private var _visibility : Double!
    private var _uv : Double!
    
    private var _weatherIcon : String!

    
    // MARK: Properties
    
    var city: String {
        if _city == nil {
            _city = ""
        }
        return _city
    }
    
    var date: Date {
        if _date == nil {
            _date = Date()
        }
        return _date
    }
    
    var datetime: String {
        if _datetime == nil {
            _datetime = ""
        }
        return _datetime
    }
    
    var uv: Double {
        if _uv == nil {
            _uv = 0.0
        }
        return _uv
    }
    
    var sunrise: String {
        if _sunrise == nil {
            _sunrise = ""
        }
        return _sunrise
    }
    
    var sunset: String {
        if _sunset == nil {
            _sunset = ""
        }
        return _sunset
    }
    
    var currentTemp: Double {
        if _currentTemp == nil {
            _currentTemp = 0.0
        }
        return _currentTemp
    }
    
    var feelsLike: Double {
        if _feelsLike == nil {
            _feelsLike = 0.0
        }
        return _feelsLike
    }
    
    
    var weatherType: String {
        if _weatherType == nil {
            _weatherType = ""
        }
        return _weatherType
    }
    
    var pressure: Double {
        if _pressure == nil {
            _pressure = 0.0
        }
        return _pressure
    }
    
    var humidity: Double {
        if _humidity == nil {
            _humidity = 0.0
        }
        return _humidity
    }
    
    var windSpeed: Double {
        if _windSpeed == nil {
            _windSpeed = 0.0
        }
        return _windSpeed
    }
    
    var weatherIcon: String {
        if _weatherIcon == nil {
            _weatherIcon = ""
        }
        return _weatherIcon
    }
    
    var visibility: Double {
        if _visibility == nil {
            _visibility = 0.0
        }
        return _visibility
    }
}

extension CurrentWeather {

    func getCurrentWeather( _ parameters : [String:Any?] ,_ completionHandler: @escaping(_ success: Bool) -> Void) {
        
        let url = WeatherBitClient.constructUrl(from: parameters, WeatherBitClient.Methods.Current)
    
        Alamofire.request(url).responseJSON { (response) in
            
            let result = response.result
            
            if result.isSuccess {
                
                let jsonData = JSON(result.value!)
                
                let data = jsonData[WeatherBitClient.JsonResponseKeys.Data][0]
                let weatherDict = data[WeatherBitClient.JsonResponseKeys.Weather]
                
                self._city = data[WeatherBitClient.JsonResponseKeys.CityName].stringValue
                self._date = convertDate(from: data[WeatherBitClient.JsonResponseKeys.Datetime].double)
                self._datetime = data[WeatherBitClient.JsonResponseKeys.Datetime].string
                
                self._currentTemp = data[WeatherBitClient.JsonResponseKeys.Temperature].double
                self._feelsLike = data[WeatherBitClient.JsonResponseKeys.AppTemperature].double
                self._weatherType = weatherDict[WeatherBitClient.JsonResponseKeys.Description].stringValue
                self._sunrise = data[WeatherBitClient.JsonResponseKeys.Sunrise].stringValue
                self._sunset = data[WeatherBitClient.JsonResponseKeys.Sunset].stringValue
                self._humidity = data[WeatherBitClient.JsonResponseKeys.Humidity].double
                self._pressure = data[WeatherBitClient.JsonResponseKeys.Pressure].double
                self._windSpeed = data[WeatherBitClient.JsonResponseKeys.WindSpeed].double
                self._visibility = data[WeatherBitClient.JsonResponseKeys.Visiblity].double
                self._uv = data[WeatherBitClient.JsonResponseKeys.UltraViolet].double
                self._weatherIcon = weatherDict[WeatherBitClient.JsonResponseKeys.Icon].stringValue
                
                completionHandler(true)
                
            } else {
                completionHandler(false)
                print("Error : \(result.error!.localizedDescription)")
            }
        }
    }
}
