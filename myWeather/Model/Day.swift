//
//  Day.swift
//  myWeather
//
//  Created by QwertY on 01.02.2022.
//

import Foundation

struct Day: Codable {
    var maxtemp_c: Double
    var maxtemp_f: Double
    var mintemp_c: Double
    var mintemp_f: Double
    var avgtemp_c: Double
    var avgtemp_f: Double
    var maxwind_mph: Double
    var maxwind_kph: Double
    var totalprecip_mm: Double
    var totalprecip_in: Double
    var avgvis_km: Double
    var avgvis_miles: Double
    var avghumidity: Double
    var daily_will_it_rain: Int
    var daily_chance_of_rain: Int
    var daily_will_it_snow: Int
    var daily_chance_of_snow: Int
    var condition: Condition
    var uv: Double
}
