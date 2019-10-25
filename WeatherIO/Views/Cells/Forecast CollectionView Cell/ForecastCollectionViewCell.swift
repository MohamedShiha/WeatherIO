//
//  ForecastCollectionViewCell.swift
//  WeatherIO
//
//  Created by Mohamed Shiha on 8/19/19.
//  Copyright © 2019 Mohamed Shiha. All rights reserved.
//

import UIKit

class ForecastCollectionViewCell: UICollectionViewCell {

    
    // MARK : Outlets
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var weatherIconImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func generateCell (_ weather : DailyForecast) {
        
        timeLabel.text = weather.date.extractTime()
        temperatureLabel.text =  String(format: "%.0f%@", weather.temperature, getTemperatureFormatString())
        weatherIconImageView.image = UIImage(named: weather.weatherIcon)
    }
}
