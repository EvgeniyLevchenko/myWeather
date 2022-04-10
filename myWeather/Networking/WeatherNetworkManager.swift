//
//  WeatherNetworkManager.swift
//  myWeather
//
//  Created by QwertY on 01.02.2022.
//

import Foundation

class WeatherNetworkManager {
    
    private let API_KEY = "7bc232b849cf4051b71200807222001"
    
    private func getResourceURL(forLocation locationName: String) -> URL {
        let urlFriendlyLocationName = locationName.replacingOccurrences(of: " ", with: "%20")
        let resourceString = "https://api.weatherapi.com/v1/forecast.json?key=\(API_KEY)&q=\(urlFriendlyLocationName)&days=3&aqi=no&alerts=no"
        guard let resourceURL = URL(string: resourceString) else { fatalError() }
        return resourceURL
    }
    
    func fetchWeather(forLocation locationName: String,
                      completion: @escaping(Result<Weather, WeatherError>) -> Void) {
        let resourceURL = getResourceURL(forLocation: locationName)
        let dataTask = URLSession.shared.dataTask(with: resourceURL) { data, _, _ in
            guard let jsonData = data else {
                completion(.failure(.noDataAvailable))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let weather = try decoder.decode(Weather.self, from: jsonData)
                completion(.success(weather))
            } catch {
                completion(.failure(.canNotProcessData))
            }
        }
        dataTask.resume()
    }
    
    private func getSearchResourceURL(forLocation locationName: String) -> URL {
        let urlFriendlyLocationName = locationName.replacingOccurrences(of: " ", with: "%20")
        let resourceString = "https://api.weatherapi.com/v1/search.json?key=\(API_KEY)&q=\(urlFriendlyLocationName)"
        guard let resourceURL = URL(string: resourceString) else { fatalError() }
        return resourceURL
    }
    
    func searchLocation(withName locationName: String,
                      completion: @escaping(Result<SearchLocations, WeatherError>) -> Void) {
        let resourceURL = getSearchResourceURL(forLocation: locationName)
        let dataTask = URLSession.shared.dataTask(with: resourceURL) { data, _, _ in
            guard let jsonData = data else {
                completion(.failure(.noDataAvailable))
                print("noDataAvailable")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let locations = try decoder.decode(SearchLocations.self, from: jsonData)
                completion(.success(locations))
            } catch {
                completion(.failure(.canNotProcessData))
            }
        }
        dataTask.resume()
    }
}
