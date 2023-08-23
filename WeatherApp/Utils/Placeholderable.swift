//
//  Placeholderable.swift
//  WeatherApp
//
//  Created by alekseevpg on 12.08.2023.
//

import Foundation

protocol Placeholderable {
    static func placeholder(id: String) -> Self
}

extension CityWeatherInfo: Placeholderable {
    static func placeholder(id: String) -> CityWeatherInfo {
        CityWeatherInfo(
            id: id,
            cityName: "Test",
            temp: 0,
            feelsLike: 0,
            tempMin: 0,
            tempMax: 0,
            weather: [
                Weather(main: "Rain", description: "Moderate Rain", icon: "10d")
            ],
            details: [
                .feelsLike(32),
                .humidiy(22),
                .pressure(777),
                .rain(23),
                .visibility(12),
                .wind(23)
            ],
            forecast: [
                WeatherForecast(
                    date: Date(),
                    tempMin: 0,
                    tempMax: 0,
                    weather: [
                        Weather(main: "Rain", description: "Moderate Rain", icon: "10d")
                    ]
                )
            ]
        )
    }
}
