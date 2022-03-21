//
//  HoursTableViewCell.swift
//  myWeather
//
//  Created by QwertY on 09.03.2022.
//

import UIKit

class HoursTableViewCell: UITableViewCell {
    
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var conditionIcon: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    static let identifier = "HoursTableViewCell"
    
    static func nib() -> UINib {
        UINib(nibName: identifier, bundle: nil)
    }
    
    func configure(hours: String, iconURL: String, temperature: Double) {
        hoursLabel.text = hours
        if let conditionIconURL = URL(string: "https:\(iconURL)") {
            conditionIcon.load(url: conditionIconURL)
        }
        temperatureLabel.text = "\(Int(round(temperature)))°"
    }
}
