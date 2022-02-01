//
//  Current.swift
//  myWeather
//
//  Created by QwertY on 01.02.2022.
//

import Foundation

struct Current: Codable {
    var last_updated_epoch: Int
    var last_updated: String
    var temp_c: Double
    var temp_f: Double
    var is_day: Int
    var condition: Condition
    var wind_mph: Double
    var wind_kph: Double
    var wind_degree: Int
    var wind_dir: String
    var pressure_mb: Double
    var pressure_in: Double
    var precip_mm: Double
    var precip_in: Double
    var humidity, cloud: Int
    var feelslike_c, feelslike_f: Double
    var vis_km, vis_miles, uv: Double
    var gust_mph, gust_kph: Double
}
