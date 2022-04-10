//
//  SearchLocation.swift
//  myWeather
//
//  Created by QwertY on 24.03.2022.
//

import Foundation

struct SearchLocation: Codable {
    let id: Int
    let name: String
    let region: String
    let country: String
    let lat, lon: Double
    let url: String
}

typealias SearchLocations = [SearchLocation]
