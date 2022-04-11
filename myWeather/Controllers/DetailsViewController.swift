//
//  DetailsViewController.swift
//  myWeather
//
//  Created by QwertY on 02.02.2022.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet private weak var lowTempLabel: UILabel!
    @IBOutlet private weak var highTempLabel: UILabel!
    @IBOutlet private weak var detailsTableView: UITableView!
    
    static let identifier = "detailsViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDetailsTableView()
        setupLowAndHighTempLabels()
        updateDetailsView()
        UserLocations.diplayedLocationChanged = updateDetailsView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        UserLocations.diplayedLocationChanged = updateDetailsView
    }
    
    private func setupDetailsTableView() {
        detailsTableView.delegate = self
        detailsTableView.dataSource = self
        detailsTableView.register(DetailsTableViewCell.nib(), forCellReuseIdentifier: DetailsTableViewCell.identifier)
        detailsTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: detailsTableView.frame.size.width, height: 1))
    }
    
    private func setupLowAndHighTempLabels() {
        updateLowAndHighTempLabels()
    }
    
    func updateDetailsView() {
        updateDetailsTableView()
        updateLowAndHighTempLabels()
    }
    
    private func updateDetailsTableView() {
        detailsTableView.reloadData()
    }
    
    private func updateLowAndHighTempLabels() {
        DispatchQueue.main.async {
            let displayedLocationIndex = UserLocations.displayedLocationIndex
            guard let displayedLocationName = UserLocations.locationNames[displayedLocationIndex].name else { return }
            if let minTemp = UserLocations.weather[displayedLocationName]?.forecast.forecastday[0].day.mintemp_c,
               let maxTemp = UserLocations.weather[displayedLocationName]?.forecast.forecastday[0].day.maxtemp_c {
                self.lowTempLabel.attributedText = self.configureTempLabel(with: minTemp)
                self.highTempLabel.attributedText = self.configureTempLabel(with: maxTemp)
            }
        }
    }
    
    private func configureTempLabel(with temp: Double) -> NSMutableAttributedString {
        let tempString = "\(Int(round(temp)))°"
        let tempText = NSMutableAttributedString.init(string: tempString)
        let fontSizeAttribute = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 40)]
        let celsiusSymbol = "C"
        let attributedCelsiusSymbol = NSMutableAttributedString(string: celsiusSymbol, attributes: fontSizeAttribute)
        tempText.append(attributedCelsiusSymbol)
        return tempText
    }
    
}

extension DetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DetailsTableViewCell.identifier, for: indexPath) as! DetailsTableViewCell
        let currentLocationNameIndex = UserLocations.displayedLocationIndex
        guard let currentLocationName = UserLocations.locationNames[currentLocationNameIndex].name else { return cell }
        switch indexPath.row {
        case 0:
            guard let windDir = UserLocations.weather[currentLocationName]?.current.wind_dir else { break }
            guard let windSpeed = UserLocations.weather[currentLocationName]?.current.wind_kph else { break }
            let windInfo = "\(windDir) \(windSpeed) KPH"
            let imageSystemName = "wind"
            let weatherElementName = "WIND"
            cell.configure(imageSystemName: imageSystemName, weatherElementName: weatherElementName, weatherElementInfo: windInfo)
        case 1:
            guard let humidity = UserLocations.weather[currentLocationName]?.current.humidity else { break }
            let humidityInfo = "\(humidity)%"
            let imageSystemName = "drop.fill"
            let weatherElementName = "HUMIDITY"
            cell.configure(imageSystemName: imageSystemName, weatherElementName: weatherElementName, weatherElementInfo: humidityInfo)
        case 2:
            guard let precipitation = UserLocations.weather[currentLocationName]?.current.precip_mm else { break }
            let precipitationInfo = "\(precipitation) mm"
            let imageSystemName = "cloud.rain.fill"
            let weatherElementName = "PRECIPITATION"
            cell.configure(imageSystemName: imageSystemName, weatherElementName: weatherElementName, weatherElementInfo: precipitationInfo)
        case 3:
            guard let pressure = UserLocations.weather[currentLocationName]?.current.pressure_mb else { break }
            let pressureInfo = "\(Int(pressure)) mm"
            let imageSystemName = "arrow.down"
            let weatherElementName = "PRESSURE"
            cell.configure(imageSystemName: imageSystemName, weatherElementName: weatherElementName, weatherElementInfo: pressureInfo)
        case 4:
            guard let visibility = UserLocations.weather[currentLocationName]?.current.vis_km else { break }
            let visibilityInfo = "\(Int(round(visibility))) km"
            let imageSystemName = "eye"
            let weatherElementName = "VISIBILITY"
            cell.configure(imageSystemName: imageSystemName, weatherElementName: weatherElementName, weatherElementInfo: visibilityInfo)
        default:
            return cell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55.0
    }

}
