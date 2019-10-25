//
//  TimeComparison.swift
//  WeatherIO
//
//  Created by Mohamed Shiha on 8/24/19.
//  Copyright © 2019 Mohamed Shiha. All rights reserved.
//

import Foundation

class Time {
    
    
    // MARK : Initialisers
    
    init(_ date : Date) {
        
        let calendar = Calendar.current
        
        let dateComponents = calendar.dateComponents([.hour, .minute], from: date)
     
        let dateSeconds = dateComponents.hour! * 3600 + dateComponents.minute! * 60
        
        secondsSinceDayBeginning = dateSeconds
        
        hour = dateComponents.hour!
        minute = dateComponents.minute!
    }
    
    init(_ hour: Int, _ minute : Int) {
        
        let dateSeconds = hour * 3600 + minute * 60
        
        secondsSinceDayBeginning = dateSeconds
        self.hour = hour
        self.minute = minute
    }
    
    // MARK : Variables
    
    var hour : Int
    var minute : Int
    
    var date : Date {
        
        let calender = Calendar.current
        
        var dateComponents = DateComponents()
        
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        return calender.date(byAdding: dateComponents, to: Date())!
    }
    
    private let secondsSinceDayBeginning : Int
    
    // MARK : Comparison Operations
    
    static func == (_ lhs : Time, rhs : Time) -> Bool {
        return lhs.secondsSinceDayBeginning == rhs.secondsSinceDayBeginning
    }
    
    static func > (_ lhs : Time, rhs : Time) -> Bool {
        return lhs.secondsSinceDayBeginning > rhs.secondsSinceDayBeginning
    }
    
    static func < (_ lhs : Time, rhs : Time) -> Bool {
        return lhs.secondsSinceDayBeginning < rhs.secondsSinceDayBeginning
    }
    
    static func >= (_ lhs : Time, rhs : Time) -> Bool {
        return lhs.secondsSinceDayBeginning >= rhs.secondsSinceDayBeginning
    }
    
    static func <= (_ lhs : Time, rhs : Time) -> Bool {
        return lhs.secondsSinceDayBeginning <= rhs.secondsSinceDayBeginning
    }
    
}

extension Date {
    
    var time: Time {
        return Time(self)
    }
}
