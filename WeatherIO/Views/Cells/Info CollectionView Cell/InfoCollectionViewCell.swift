//
//  InfoCollectionViewCell.swift
//  WeatherIO
//
//  Created by Mohamed Shiha on 8/19/19.
//  Copyright © 2019 Mohamed Shiha. All rights reserved.
//

import UIKit

class InfoCollectionViewCell: UICollectionViewCell {

    // MARK : Outlets
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var infoImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func generateCell (weatherInfo : WeatherInfo) {
        infoLabel.text = weatherInfo.info
        infoLabel.adjustsFontSizeToFitWidth = true
        
        if let image = weatherInfo.image {
            nameLabel.isHidden = true
            infoImageView.isHidden = false
            infoImageView.image = image
        } else {
            infoImageView.isHidden = true
            nameLabel.isHidden = false
            nameLabel.text = weatherInfo.name
            nameLabel.adjustsFontSizeToFitWidth = true
        }
    }
}
