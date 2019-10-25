//
//  WeatherTableViewCell.swift
//  WeatherIO
//
//  Created by Mohamed Shiha on 8/19/19.
//  Copyright © 2019 Mohamed Shiha. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

    // MARK: Outlets
    
    @IBOutlet weak var dayOfTheWeekLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var weatherIconImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func generateCell (_ weeklyForecast : WeeklyForecast) {
        dayOfTheWeekLabel.text = weeklyForecast.date.dayOfTheWeek()
        temperatureLabel.text = String(format: "%.0f%@", weeklyForecast.temperature, getTemperatureFormatString())
        weatherIconImageView.image = UIImage(named: weeklyForecast.weatherIcon)
    }
}
