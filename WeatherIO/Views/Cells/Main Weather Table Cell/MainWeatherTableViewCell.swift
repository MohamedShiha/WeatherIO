//
//  MainWeatherTableViewCell.swift
//  WeatherIO
//
//  Created by Mohamed Shiha on 8/20/19.
//  Copyright © 2019 Mohamed Shiha. All rights reserved.
//

import UIKit

class MainWeatherTableViewCell: UITableViewCell {

    
    // MARK : Outlets
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func generateCell ( _ weatherData : CityTempData) {
        
        cityLabel.text = weatherData.city
        cityLabel.adjustsFontSizeToFitWidth = true
        temperatureLabel.text = String(format: "%.0f %@", weatherData.temperature, getTemperatureFormatString())
    }
}
