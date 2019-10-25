//
//  dailyForecast.swift
//  WeatherIO
//
//  Created by Mohamed Shiha on 8/19/19.
//  Copyright © 2019 Mohamed Shiha. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class DailyForecast {
    
    // MARK : Variables
    
    private var _date : Date!
    private var _temprature : Double!
    private var _weatherIcon : String!
    
    
    // MARK: Properties
    
    var date: Date {
        if _date == nil {
            _date = Date()
        }
        return _date
    }
    
    var temperature : Double {
        if _temprature == nil {
            _temprature = 0.0
        }
        return _temprature
    }
    
    var weatherIcon : String {
        if _weatherIcon == nil {
            _weatherIcon = ""
        }
        return _weatherIcon
    }
    
    
    // MARK : Initialiser
    
    init(weatherDictionary : Dictionary<String,AnyObject>) {
        let jsonData = JSON(weatherDictionary)
        
        self._temprature = jsonData[WeatherBitClient.JsonResponseKeys.Temperature].doubleValue
        self._date = convertDate(from: jsonData[WeatherBitClient.JsonResponseKeys.TimeStamp].double!)
        self._weatherIcon = jsonData[WeatherBitClient.JsonResponseKeys.Weather][WeatherBitClient.JsonResponseKeys.Icon].stringValue
    }
}


extension DailyForecast {
    
    class func downloadDailyForecastWeather ( _ parameters : [String:Any?] , _ completionHandler : @escaping(_ dailyForecast: [DailyForecast]) -> Void) {
        
        var modifiedParameters = parameters
        modifiedParameters["hours"] = "24"
        
        let url = WeatherBitClient.constructUrl(from: modifiedParameters, WeatherBitClient.Methods.DailyForecast)
        
        Alamofire.request(url).responseJSON { (response) in
            
            let result = response.result
            
            var forecastArray : [DailyForecast] = []
            
            if result.isSuccess {
                
                if let dictionary = result.value as? Dictionary<String,AnyObject> {
                    if let weatherByHour = dictionary[WeatherBitClient.JsonResponseKeys.Data] as? [Dictionary<String,AnyObject>] {
                        
                        for hour in weatherByHour {
                            let dailyForecast = DailyForecast(weatherDictionary: hour)
                            forecastArray.append(dailyForecast)
                        }
                    }
                }
            } else {
                print("Error : \(result.error!.localizedDescription)")
            }
            
            completionHandler(forecastArray)
        }
    }
}
