//
//  UserDefaults.swift
//  WeatherIO
//
//  Created by Mohamed Shiha on 8/20/19.
//  Copyright © 2019 Mohamed Shiha. All rights reserved.
//

import Foundation


class UserCongifuration {
    
    // MARK : Variables
    static let userDefaults = UserDefaults.standard
    static var shouldRefresh = true
    
    public static func saveToUserDefaults(_ savedLocations : [WeatherLocation], _ key : String) {
//        print("Write to UserDefaults")
        shouldRefresh = true
        userDefaults.set( try? PropertyListEncoder().encode(savedLocations), forKey: key)
        userDefaults.synchronize()
    }
    
    public static func saveTemperatureFormat(value : Int, _ key : String) {
//        print("Write to UserDefaults")
        shouldRefresh = true
        userDefaults.set(value, forKey: key)
        userDefaults.synchronize()
    }
    
    public static func loadFromUserDefaults (key : String) -> [WeatherLocation]? {
        
        if let data = userDefaults.value(forKey: key) as? Data {
//            print("Read from UserDefaults")
            return try? PropertyListDecoder().decode(Array<WeatherLocation>.self, from: data)
        } else {
            print("No user data in User Defaults")
            return [WeatherLocation]()
        }
    }
    
    public static func loadTemperatureFormat (key : String) -> Int? {
        
        if let formatIndex = userDefaults.value(forKey: key) as? Int {
//            print("Read from UserDefaults")
            return formatIndex
        } else {
            print("No user data in User Defaults")
            return 0
        }
    }
}
