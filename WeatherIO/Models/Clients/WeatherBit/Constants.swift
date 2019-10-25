//
//  Constants.swift
//  WeatherIO
//
//  Created by Mohamed Shiha on 8/16/19.
//  Copyright © 2019 Mohamed Shiha. All rights reserved.
//

import Foundation

class WeatherBitClient {
    
    // Mark: Constants
    struct Constants {
        
        // URL Component
        static let ApiScheme = "https"
        static let ApiHost = "api.weatherbit.io"
        static let ApiPath = "/v2.0"
        
//        static let Api_Key = "0bf12bc659764e2e98f6213ecac8c203"
        static let Api_Key = "d4190f7647a8407fb067a70bddc45689"
    }
    
    // MARK: Methods
    struct Methods {
        static let Current = "/current"
        static let HourlyForecast = "/forecast/hourly"
        static let DailyForecast = "/forecast/daily"
    }
    
    // Mark: QueryParamterKeys
    struct QueryParamterKeys {
        static let Api_Key = "key"
        
//        static let CityID = "city_id"
        static let City = "city"
//        static let State = "state"
//        static let Country = "country"
//        static let PostalCode = "postal_code"
        
        static let Latitude = "lat"
        static let Longitude = "lon"
        
//        static let Language = "lang" // Default = En
        static let Units = "units" // Default = Metric (Celcius, m/s, mm)
    }
    
    // Mark: JsonResponseKeys
    struct JsonResponseKeys {
        
        static let Data = "data"
        
        // Location
        static let CountryCode  = "country_code"
        static let CityName = "city_name"
        
        // Time
        static let Datetime = "datetime"
        static let TimeStamp = "ts"
        
        // Weather
        static let Weather = "weather"
        static let Icon = "icon"
        static let Description = "description"
        
        // Forecast Data
        static let Temperature = "temp"
        static let AppTemperature = "app_temp" // Feels Like
        static let Sunrise = "sunrise"
        static let Sunset = "sunset"
//        static let Snow = "snow"      Not Used
        static let Visiblity = "vis"
        static let UltraViolet = "uv"
//        static let WindDirection = "wind_dir"      Not Used
        static let WindSpeed = "wind_spd"
        static let Pressure = "pres"
        static let Humidity = "rh"
//        static let ElevationAngle = "elev_angle"      Not Used
    }
    
    static func constructUrl(from parameters : [String:Any?], _ withPathExtention : String?) -> String {
        
        var components = URLComponents()
        components.scheme = Constants.ApiScheme
        components.host = Constants.ApiHost
        components.path = Constants.ApiPath + (withPathExtention ?? "")
        
        var queryItems = [URLQueryItem]()
        
        queryItems.append(URLQueryItem(name: WeatherBitClient.QueryParamterKeys.Api_Key, value:
            WeatherBitClient.Constants.Api_Key))
//        queryItems.append(URLQueryItem(name: WeatherBitClient.QueryParamterKeys.City, value: "Raleigh"))
        
        for queryItem in parameters {
            queryItems.append(URLQueryItem(name: queryItem.key, value: queryItem.value as? String))
        }
        components.queryItems = queryItems
        
        return (components.url?.absoluteString)!
    }
}
