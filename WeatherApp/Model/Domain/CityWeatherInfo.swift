//
//  CityWeather.swift
//  WeatherApp
//
//  Created by alekseevpg on 11.08.2023.
//

import Foundation

struct CityWeatherInfo: Identifiable {
    let id: String
    let cityName: String
    let temp, feelsLike, tempMin, tempMax: Double

    let weather: [Weather]
    let details: [WeatherDetails]

    let forecast: [WeatherForecast]
}

struct WeatherForecast: Identifiable {
    var id: Date { date }
    let date: Date
    let tempMin, tempMax: Double

    let weather: [Weather]
}

extension CityWeatherInfo {
    var isNight: Bool {
        weather.first?.icon.contains("n") ?? false
    }
}

extension CityWeatherInfo: Equatable {
    static func == (lhs: CityWeatherInfo, rhs: CityWeatherInfo) -> Bool {
        lhs.id == rhs.id
    }
}

enum WeatherDetails {
    case visibility(Int)
    case feelsLike(Int)
    case humidiy(Int)
    case pressure(Int)
    case wind(Int)
    case rain(Int)
}

struct Weather {
    let main, description, icon: String
}

extension Weather {
    var lottieAnimationName: String {
        switch icon {
        case "01d":
            return "dayClearSky"
        case "01n":
            return "nightClearSky"
        case "02d":
            return "dayFewClouds"
        case "02n":
            return "nightFewClouds"
        case "03d":
            return "dayScatteredClouds"
        case "03n":
            return "nightScatteredClouds"
        case "04d":
            return "dayBrokenClouds"
        case "04n":
            return "nightBrokenClouds"
        case "09d":
            return "dayShowerRains"
        case "09n":
            return "nightShowerRains"
        case "10d":
            return "dayRain"
        case "10n":
            return "nightRain"
        case "11d":
            return "dayThunderstorm"
        case "11n":
            return "nightThunderstorm"
        case "13d":
            return "daySnow"
        case "13n":
            return "nightSnow"
        case "50d":
            return "dayClearSky"
        case "50n":
            return "dayClearSky"
        default:
            return "dayClearSky"
        }
    }

    var systemIconName: String {
        switch icon {
        case "01d":
            return "sun.max.fill"
        case "01n":
            return "moon.fill"
        case "02d":
            return "cloud.sun.fill"
        case "02n":
            return "cloud.moon.fill"
        case "03d", "03n", "04d", "04n":
            return "cloud.fill"
        case "09d", "09n":
            return "cloud.drizzle.fill"
        case "10d",  "10n":
            return "cloud.heavyrain.fill"
        case "11d", "11n":
            return "cloud.bolt.fill"
        case "13d", "13n":
            return "cloud.snow.fill"
        case "50d", "50n":
            return "cloud.fog.fill"
        default:
            return "sun.max.fill"
        }
    }
}
