//
//  CurrentWeatherCollectionViewCell.swift
//  myWeather
//
//  Created by QwertY on 09.03.2022.
//

import UIKit

class CurrentWeatherCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var currentTempLabel: UILabel!
    @IBOutlet private weak var currentConditionLabel: UILabel!
    @IBOutlet private weak var locationLabel: UILabel!
    @IBOutlet private weak var currentConditionIcon: UIImageView!

    static let identifier = "CurrentWeatherCollectionViewCell"
    
    static func nib() -> UINib {
        UINib(nibName: identifier, bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.layer.cornerRadius = 57.5   
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true
    }
    
    func configure(temp: Double, condition: String, location: String, iconURL: String) {
        configureCurrentTempLabel(temp: temp)
        currentConditionLabel.text = condition
        locationLabel.text = location
        if let conditionIconURL = URL(string: "https:\(iconURL)") {
            currentConditionIcon.load(url: conditionIconURL)
        }
    }

    private func configureCurrentTempLabel(temp: Double) {
        let tempString = "\(Int(round(temp)))°"
        let tempText = NSMutableAttributedString.init(string: tempString)
        let fontSizeAttribute = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 40)]
        let celsiusSymbol = "C"
        let attributedCelsiusSymbol = NSMutableAttributedString(string: celsiusSymbol, attributes: fontSizeAttribute)
        tempText.append(attributedCelsiusSymbol)
        currentTempLabel.attributedText = tempText
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
