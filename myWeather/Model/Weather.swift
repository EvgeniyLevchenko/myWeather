//
//  Weather.swift
//  myWeather
//
//  Created by QwertY on 01.02.2022.
//

import Foundation

struct Weather: Codable {
    var location: Location
    var current: Current
    var forecast: Forecast
}
