//
//  Forecastday.swift
//  myWeather
//
//  Created by QwertY on 01.02.2022.
//

import Foundation

struct Forecastday: Codable {
    var date: String
    var date_epoch: Int
    var day: Day
    var astro: Astro
    var hour: [Hour]
}
