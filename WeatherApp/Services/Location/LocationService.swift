//
//  LocationManager.swift
//  WeatherApp
//
//  Created by alekseevpg on 11.08.2023.
//

import Foundation
import Combine
import CoreLocation

typealias Location = CLLocationCoordinate2D

enum LocationError: Error {
    case authorizationDenied
}

final class LocationService: NSObject {
    private typealias LocationCheckedThrowingContinuation = CheckedContinuation<Location, Error>

    private lazy var locationManager = CLLocationManager()

    private var continuations: [LocationCheckedThrowingContinuation] = []

    var locationServicesAuthorized: Bool {
        let status = locationManager.authorizationStatus
        return status == .authorizedAlways || status == .authorizedWhenInUse
    }

    var locationServicesRestricted: Bool {
        let status = locationManager.authorizationStatus
        return status == .denied || status == .restricted
    }

    func updateLocation() async throws -> Location {
        try await withCheckedThrowingContinuation { [weak self] continuation in
            guard let self = self else {
                return
            }

            self.continuations.append(continuation)

            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.requestLocation()
        }
    }
}

extension LocationService: CLLocationManagerDelegate {
    func locationManager(_: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let locationObj = locations.last {
            let coord = locationObj.coordinate
            let location = Location(latitude: coord.latitude, longitude: coord.longitude)
            continuations.forEach { $0.resume(returning: location) }
        }
        continuations.removeAll()
    }

    func locationManager(_: CLLocationManager, didFailWithError error: Error) {
        if locationServicesRestricted {
            continuations.forEach { $0.resume(throwing: LocationError.authorizationDenied) }
        } else {
            continuations.forEach { $0.resume(throwing: error) }
        }
        continuations.removeAll()
    }
}
