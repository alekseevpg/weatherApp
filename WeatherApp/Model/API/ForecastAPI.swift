//
//  ForecastAPI.swift
//  WeatherApp
//
//  Created by alekseevpg on 13.08.2023.
//

import Foundation

struct ForecastAPI: Decodable {
    let list: [ForecastWeatherAPI]
    let city: CityAPI
}

struct ForecastWeatherAPI: Decodable {
    let dt: Date
    let main: Main
    let weather: [WeatherAPI]
}

struct CityAPI: Decodable {
    let timezone: Double
}
