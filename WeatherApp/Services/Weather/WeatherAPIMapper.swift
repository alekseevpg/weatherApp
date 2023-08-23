//
//  WeatherAPIMapper.swift
//  WeatherApp
//
//  Created by alekseevpg on 13.08.2023.
//

import Foundation

protocol WeatherAPIMapping {
    func cityWeather(
        from weatherAPI: CurrentWeatherAPI,
        and geocodeAPI: [ReverseGeocodeAPI],
        and forecastAPI: ForecastAPI
    ) -> CityWeatherInfo
}

class WeatherAPIMapper: WeatherAPIMapping {
    func cityWeather(
        from weatherAPI: CurrentWeatherAPI,
        and geocodeAPI: [ReverseGeocodeAPI],
        and forecastAPI: ForecastAPI
    ) -> CityWeatherInfo {
        var details: [WeatherDetails] = [
            .feelsLike(Int(weatherAPI.main.feelsLike)),
            .humidiy(weatherAPI.main.humidity),
            .pressure(Int(weatherAPI.main.pressure * 0.75)),
            .visibility(weatherAPI.visibility / 1000)
        ]
        if let windSpeed = weatherAPI.wind?.speed {
            details.append(.wind(Int(windSpeed)))
        }
        if let rain = weatherAPI.rain?.the1H {
            details.append(.rain(Int(rain)))
        }
        return CityWeatherInfo(
            id: "\(weatherAPI.id)",
            cityName: geocodeAPI.first?.name ?? "Unknown City",
            temp: weatherAPI.main.temp,
            feelsLike: weatherAPI.main.feelsLike,
            tempMin: weatherAPI.main.tempMin,
            tempMax: weatherAPI.main.tempMax,
            weather: weatherAPI.weather.map(weather(from:)),
            details: details,
            forecast: forecastAPI.list.map {
                WeatherForecast(
                    date: $0.dt.addingTimeInterval(forecastAPI.city.timezone),
                    tempMin: $0.main.tempMin,
                    tempMax: $0.main.tempMax,
                    weather: $0.weather.map(weather(from:))
                )
            }
        )
    }
    
    private func weather(from api: WeatherAPI) -> Weather {
        Weather(main: api.main, description: api.description, icon: api.icon)
    }
}
