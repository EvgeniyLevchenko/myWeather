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
        MyLocations.diplayedLocationChanged = updateDetailsView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        MyLocations.diplayedLocationChanged = updateDetailsView
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
            let displayedLocationIndex = MyLocations.displayedLocationIndex
            let displayedLocationName = MyLocations.locationNames[displayedLocationIndex]
            if let minTemp = MyLocations.weather[displayedLocationName]?.forecast.forecastday[0].day.mintemp_c,
               let maxTemp = MyLocations.weather[displayedLocationName]?.forecast.forecastday[0].day.maxtemp_c {
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
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DetailsTableViewCell.identifier, for: indexPath) as! DetailsTableViewCell
        let currentLocationNameIndex = MyLocations.displayedLocationIndex
        let currentLocationName = MyLocations.locationNames[currentLocationNameIndex]
        switch indexPath.row {
        case 0:
            guard let windDir = MyLocations.weather[currentLocationName]?.current.wind_dir else { break }
            guard let windSpeed = MyLocations.weather[currentLocationName]?.current.wind_kph else { break }
            let windInfo = "\(windDir) \(windSpeed) KPH"
            let imageSystemName = "wind"
            let weatherElementName = "WIND"
            cell.configure(imageSystemName: imageSystemName, weatherElementName: weatherElementName, weatherElementInfo: windInfo)
        case 1:
            guard let humidity = MyLocations.weather[currentLocationName]?.current.humidity else { break }
            let humidityInfo = "\(humidity)%"
            let imageSystemName = "drop.fill"
            let weatherElementName = "HUMIDITY"
            cell.configure(imageSystemName: imageSystemName, weatherElementName: weatherElementName, weatherElementInfo: humidityInfo)
        case 2:
            guard let precipitation = MyLocations.weather[currentLocationName]?.current.precip_mm else { break }
            let precipitationInfo = "\(precipitation) mm"
            let imageSystemName = "cloud.rain.fill"
            let weatherElementName = "PRECIPITATION"
            cell.configure(imageSystemName: imageSystemName, weatherElementName: weatherElementName, weatherElementInfo: precipitationInfo)
        case 3:
            guard let pressure = MyLocations.weather[currentLocationName]?.current.pressure_mb else { break }
            let pressureInfo = "\(pressure) mm"
            let imageSystemName = "arrow.down"
            let weatherElementName = "PRESSURE"
            cell.configure(imageSystemName: imageSystemName, weatherElementName: weatherElementName, weatherElementInfo: pressureInfo)
        case 4:
            guard let visibility = MyLocations.weather[currentLocationName]?.current.vis_km else { break }
            let visibilityInfo = "\(visibility) km"
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
