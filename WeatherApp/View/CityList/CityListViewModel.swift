//
//  CityListViewModel.swift
//  WeatherApp
//
//  Created by alekseevpg on 12.08.2023.
//

import Foundation
import CoreLocation
import UIKit

struct CityCoordinate {
    let location: Location
    let isCurrentLocation: Bool
}

@MainActor
class CityListViewModel: ObservableObject {

    @Published var isLoading: Bool = true
    @Published var backendError: BackendError?
    @Published var weathers: [CityWeatherInfo] = [
        CityWeatherInfo.placeholder(id: "1"),
        CityWeatherInfo.placeholder(id: "2"),
        CityWeatherInfo.placeholder(id: "3"),
        CityWeatherInfo.placeholder(id: "4")
    ]

    private var coordinates: [CityCoordinate] = [
        CityCoordinate(location: Location(latitude: 13.717487, longitude: 100.503229), isCurrentLocation: false), // BKK
        CityCoordinate(location: Location(latitude: 40.595948, longitude: -74.117060), isCurrentLocation: false), // NY
        CityCoordinate(location: Location(latitude: 31.769965, longitude: 35.222748), isCurrentLocation: false)   // JRS
    ]

    var locationServicesRestricted: Bool {
        locationService.locationServicesRestricted
    }

    private let weatherService: WeatherService
    private let locationService: LocationService
    
    init(
        weatherService: WeatherService,
        locationService: LocationService
    ) {
        self.weatherService = weatherService
        self.locationService = locationService
    }

    func requestAuthorization() async {
        if locationService.locationServicesRestricted {
            let settingsUrl = URL(string: UIApplication.openSettingsURLString)
            if let url = settingsUrl {
                await UIApplication.shared.open(url)
            }
        } else {
            await fetchWeather()
        }
    }

    func fetchWeather() async {
        defer {
            isLoading = false
        }
        isLoading = true
        do {
            await fetchCurrentLocation()
            let result = try await withThrowingTaskGroup(
                of: (Int, CityWeatherInfo).self,
                returning: [CityWeatherInfo].self
            ) { [weak self] group in
                guard let self else { return [] }
                for (index, coordinate) in coordinates.enumerated() {
                    group.addTask {
                        return (index, try await self.weatherService.getCityWeather(
                            lat: coordinate.location.latitude,
                            lon: coordinate.location.longitude
                        ))
                    }
                }

                var response: [Int: CityWeatherInfo] = [:]

                for try await result in group {
                    response[result.0] = result.1
                }

                let sorted = response.sorted(by: { $0.key < $1.key }).map { $0.value }
                return Array(sorted)
            }
            weathers = result
        } catch let error as BackendError {
            weathers = []
            log.error(error)
            backendError = error
        } catch {
            weathers = []
            log.error(error)
        }
    }

    private func fetchCurrentLocation() async {
        do {
            let location = try await locationService.updateLocation()
            coordinates.removeAll(where: { $0.isCurrentLocation })
            coordinates.insert(
                CityCoordinate(location: location, isCurrentLocation: true),
                at: 0
            )
        } catch let error as BackendError {
            log.error(error)
            backendError = error
        } catch {
            log.error(error)
        }
    }
}
