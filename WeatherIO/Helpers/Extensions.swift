//
//  Extensions.swift
//  WeatherIO
//
//  Created by Mohamed Shiha on 8/19/19.
//  Copyright © 2019 Mohamed Shiha. All rights reserved.
//

import Foundation


extension Date {
    
    func shortenDate() -> String {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "MMM d"
        
        return dateFormatter.string(from: self)
    }
    
    func extractTime () -> String {
        
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "HH:mm"
        
        return dateFormatter.string(from: self)
    }
    
    func dayOfTheWeek () -> String {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "EEEE"
        
        return dateFormatter.string(from: self)
    }
}
