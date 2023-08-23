//
//  WeatherService.swift
//  WeatherApp
//
//  Created by alekseevpg on 11.08.2023.
//

import Foundation

enum WeatherServiceError: Error {
    case malformedURL
}

class WeatherService {
    private let networking: Networking
    private let mapper: WeatherAPIMapping

    private let baseURL = "https://api.openweathermap.org/"
    // We should store apiKeys in separate .env file which shouldn't be commited in git.
    // But for the sake of test project should be fine here
    private let apiKey = ""

    init(
        networking: Networking,
        mapper: WeatherAPIMapping
    ) {
        self.networking = networking
        self.mapper = mapper
    }

    func getCityWeather(lat: Double, lon: Double) async throws -> CityWeatherInfo {
        async let weather = fetchWeather(lat: lat, lon: lon)
        async let geocode = reverseGeocode(lat: lat, lon: lon)
        async let forecast = fetchForecast(lat: lat, lon: lon)

        let result = try await (weather, geocode, forecast)
        return mapper.cityWeather(from: result.0, and: result.1, and: result.2)
    }

    private func fetchWeather(lat: Double, lon: Double) async throws -> CurrentWeatherAPI {
        guard let url = URL(string: "\(baseURL)data/2.5/weather?lat=\(lat)&lon=\(lon)&units=metric&appid=\(apiKey)") else {
            throw WeatherServiceError.malformedURL
        }
        let resource = Resource<CurrentWeatherAPI>(get: url)
        return try await networking.load(resource)
    }

    private func fetchForecast(lat: Double, lon: Double) async throws -> ForecastAPI {
        guard let url = URL(string: "\(baseURL)data/2.5/forecast?lat=\(lat)&lon=\(lon)&cnt=10&units=metric&appid=\(apiKey)") else {
            throw WeatherServiceError.malformedURL
        }
        let resource = Resource<ForecastAPI>(get: url)
        return try await networking.load(resource)
    }

    private func reverseGeocode(lat: Double, lon: Double) async throws -> [ReverseGeocodeAPI] {
        guard let url = URL(string: "\(baseURL)geo/1.0/reverse?lat=\(lat)&lon=\(lon)&appid=\(apiKey)") else {
            throw WeatherServiceError.malformedURL
        }
        let resource = Resource<[ReverseGeocodeAPI]>(get: url)
        return try await networking.load(resource)
    }
}
