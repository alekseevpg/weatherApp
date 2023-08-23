//
//  CurrentWeatherAPI.swift
//  WeatherApp
//
//  Created by alekseevpg on 11.08.2023.
//

import Foundation

struct CurrentWeatherAPI: Decodable {
    let id: Int
    let weather: [WeatherAPI]
    let base: String
    let main: Main
    let visibility: Int
    let wind: Wind?
    let rain: Rain?
    let dt: Date
    let timezone: Int
    let name: String
    let cod: Int
}

struct Main: Decodable {
    let temp, feelsLike, tempMin, tempMax, pressure: Double
    let humidity: Int

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
    }
}

struct Rain: Decodable {
    let the1H: Double

    enum CodingKeys: String, CodingKey {
        case the1H = "1h"
    }
}

// MARK: - Weather
struct WeatherAPI: Decodable {
    let id: Int
    let main, description, icon: String
}

// MARK: - Wind
struct Wind: Decodable {
    let speed: Double
}
