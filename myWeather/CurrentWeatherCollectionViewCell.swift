//
//  CurrentWeatherCollectionViewCell.swift
//  myWeather
//
//  Created by QwertY on 03.02.2022.
//

import UIKit

class CurrentWeatherCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var currentTempLabel: UILabel!
    @IBOutlet private weak var currentConditionLabel: UILabel!
    @IBOutlet private weak var locationLabel: UILabel!
    @IBOutlet private weak var currentConditionIcon: UIImageView!
    
    static let identifier = "currentWeatherCollectionViewCell"

    func configureCell(temp: Double, condition: String, location: String) {
        configureCurrentTempLabel(temp: temp)
        currentConditionLabel.text = condition
        locationLabel.text = location
    }
    
    private func configureCurrentTempLabel(temp: Double) {
        let tempString = "\(Int(round(temp)))°"
        let tempText = NSMutableAttributedString.init(string: tempString)
        let fontSizeAttribute = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 40)]
        let celsiusSymbol = "C"
        let attributedCelsiusSymbol = NSMutableAttributedString(string: celsiusSymbol, attributes: fontSizeAttribute)
        tempText.append(attributedCelsiusSymbol)
        currentTempLabel.attributedText = tempText
    }
}
