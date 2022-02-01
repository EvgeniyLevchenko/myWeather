//
//  Astro.swift
//  myWeather
//
//  Created by QwertY on 01.02.2022.
//

import Foundation

struct Astro: Codable {
    var sunrise: String
    var sunset: String
    var moonrise: String
    var moonset: String
    var moon_phase: String
    var moon_illumination: String
}
