//
//  DaysViewController.swift
//  myWeather
//
//  Created by QwertY on 02.02.2022.
//

import UIKit

class DaysViewController: UIViewController {

    @IBOutlet private weak var daylyWeatherTableView: UITableView!
    
    static let identifier = "daysViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDaylyWeatherTableView()
        updateDaylyWeatherTableView()
        UserLocations.diplayedLocationChanged = updateDaylyWeatherTableView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        UserLocations.diplayedLocationChanged = updateDaylyWeatherTableView
    }
    
    private func setupDaylyWeatherTableView() {
        daylyWeatherTableView.delegate = self
        daylyWeatherTableView.dataSource = self
        daylyWeatherTableView.register(DaysTableViewCell.nib(), forCellReuseIdentifier: DaysTableViewCell.identifier)
        daylyWeatherTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: daylyWeatherTableView.frame.size.width, height: 1))
    }
    
    func updateDaylyWeatherTableView() {
        daylyWeatherTableView.reloadData()
    }
    
    private func getDayOfWeek(withAddedDays value: Int) -> String {
        if value == 0 {
            return "Today"
        }
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        if let nextDate = Calendar.current.date(byAdding: .day, value: value, to: currentDate) {
            dateFormatter.dateFormat = "EEEE"
            let dayOfWeek = dateFormatter.string(from: nextDate).capitalized
            return dayOfWeek
        } else {
            return ""
        }
    }
    
    private func getDate(withAddedComponent component: Calendar.Component, addedValue: Int, inDateFormat format: String) -> String? {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        if let nextDate = Calendar.current.date(byAdding: component, value: addedValue, to: currentDate) {
            dateFormatter.dateFormat = format
            let dateToString = dateFormatter.string(from: nextDate)
            return dateToString
        } else {
            return nil
        }
    }
}

extension DaysViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DaysTableViewCell.identifier, for: indexPath) as! DaysTableViewCell
        let currentLocationNameIndex = UserLocations.displayedLocationIndex
        guard let currentLocationName = UserLocations.locationNames[currentLocationNameIndex].name else { return cell }
        guard let daylyWeather = UserLocations.weather[currentLocationName]?.forecast.forecastday[indexPath.row].day else { return cell }
        let dayOfWeek = getDayOfWeek(withAddedDays: indexPath.row)
        let conditionIcon = daylyWeather.condition.icon
        let minTemp = daylyWeather.mintemp_c
        let maxTemp = daylyWeather.maxtemp_c
        cell.configure(dayOfWeek: dayOfWeek, iconURL: conditionIcon, minTemp: minTemp, maxTemp: maxTemp)
        return cell
    }

}
