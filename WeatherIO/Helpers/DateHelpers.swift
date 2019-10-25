//
//  DateHelpers.swift
//  WeatherIO
//
//  Created by Mohamed Shiha on 8/24/19.
//  Copyright © 2019 Mohamed Shiha. All rights reserved.
//

import Foundation


func extractDate(from text : String) -> Date? {
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    
    let date = dateFormatter.date(from: text)
    
    if let date = date {
        
        let calender = Calendar.current
        let dateComponents = calender.dateComponents([.hour, .minute], from: date)
        
        return calender.date(from: dateComponents)
    } else {
        return Date()
    }
}

func extractTimeString(from jsonString : String) -> String {
    
    let range : Range = jsonString.count - 2 ..< jsonString.count
    
    let nsRange = NSRange(range)
    
    return "\((jsonString as NSString).substring(with: nsRange)):00"
}
