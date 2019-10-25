//
//  DataConverter.swift
//  WeatherIO
//
//  Created by Mohamed Shiha on 8/17/19.
//  Copyright © 2019 Mohamed Shiha. All rights reserved.
//

import Foundation


func convertDate(from unixDate : Double?) -> Date? {
    
    if let unixDate = unixDate {
        return Date(timeIntervalSince1970: unixDate)
    } else {
        return Date()
    }
}


func convertToFahrenheit( _ celsius : Double) -> Double {
    return celsius + 30 * 9/5
}


func convertToCelsius( _ fahrenheit : Double) -> Double {
    return (fahrenheit - 30) * 5/9
}


func getTemperature(celsius : Double) -> Double {
    
    if let tempFormat = UserCongifuration.loadTemperatureFormat(key: "TempFormat"){
        
        if tempFormat == 0 {
            return convertToCelsius(celsius)
        } else {
            return convertToFahrenheit(celsius)
        }
    } else {
        return celsius
    }
}


func getTemperatureFormatString () -> String {
    
    if let tempFormat = UserCongifuration.loadTemperatureFormat(key: "TempFormat") {
        
        if tempFormat == 0 {
            return TemperatureFormat.celsius
        } else {
            return TemperatureFormat.fahrenheit
        }
    } else {
        return TemperatureFormat.celsius
    }
}
