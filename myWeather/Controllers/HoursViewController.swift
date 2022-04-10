//
//  HoursViewController.swift
//  myWeather
//
//  Created by QwertY on 02.02.2022.
//

import UIKit

class HoursViewController: UIViewController {

    @IBOutlet private weak var hourlyWeatherTableView: UITableView!
    
    static let identifier = "hoursViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHoursTableView()
        updateHourlyTableView()
        UserLocations.diplayedLocationChanged = updateHourlyTableView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        UserLocations.diplayedLocationChanged = updateHourlyTableView
    }
    
    func updateHourlyTableView() {
        hourlyWeatherTableView.reloadData()
    }

    private func setupHoursTableView() {
        hourlyWeatherTableView.delegate = self
        hourlyWeatherTableView.dataSource = self
        hourlyWeatherTableView.register(HoursTableViewCell.nib(), forCellReuseIdentifier: HoursTableViewCell.identifier)
        hourlyWeatherTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: hourlyWeatherTableView.frame.size.width, height: 1))
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
    
    private func getHours(for row: Int) -> String {
        if row == 0 {
            return "Now"
        } else {
            let dateFormat = "HH:00"
            if let currentHour = getDate(withAddedComponent: .hour, addedValue: row, inDateFormat: dateFormat) {
                return currentHour
            } else {
                return ""
            }
        }
    }
    
}

extension HoursViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HoursTableViewCell.identifier, for: indexPath) as! HoursTableViewCell
        let dateFormat = "y-MM-dd HH:00"
        let date = getDate(withAddedComponent: .hour, addedValue: indexPath.row, inDateFormat: dateFormat)
        let currentLocationNameIndex = UserLocations.displayedLocationIndex
        guard let currentLocationName = UserLocations.locationNames[currentLocationNameIndex].name else { return cell }
        for i in 0...1 {
            if let hourlyWeather = UserLocations.weather[currentLocationName]?.forecast.forecastday[i].hour {
                if let weatherForHour = hourlyWeather.first(where: { $0.time == date }) {
                    let hours = getHours(for: indexPath.row)
                    let conditionIcon = weatherForHour.condition.icon
                    let temperature = weatherForHour.temp_c
                    cell.configure(hours: hours, iconURL: conditionIcon, temperature: temperature)
                }
            }
        }
        return cell
    }
    
    
    
}
