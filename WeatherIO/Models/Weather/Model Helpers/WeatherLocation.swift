//
//  WeatherLocation.swift
//  WeatherIO
//
//  Created by Mohamed Shiha on 8/19/19.
//  Copyright © 2019 Mohamed Shiha. All rights reserved.
//

import Foundation

struct WeatherLocation : Codable, Equatable {
    var city : String!
    var country : String!
    var countryCode : String!
    var isCurrentLocation : Bool!
}
