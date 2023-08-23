//
//  DependencyContainer.swift
//  WeatherApp
//
//  Created by alekseevpg on 01.02.2023.
//

import Foundation
import Swinject

struct DependencyContainer {

    static let shared = DependencyContainer()

    private var container = Swinject.Container { container in
        container.register(Networking.self) { resolver in
            Networkable()
        }
        container.register(LocationService.self) { resolver in
            LocationService()
        }
        container.register(WeatherAPIMapping.self) { resolver in
            WeatherAPIMapper()
        }
        container.register(WeatherService.self) { resolver in
            WeatherService(
                networking: resolver.resolve(Networking.self)!,
                mapper: resolver.resolve(WeatherAPIMapping.self)!
            )
        }
    }

    func resolve<Service>(_ serviceType: Service.Type) -> Service? {
        container.synchronize().resolve(serviceType)
    }

    func resolve<Service>() -> Service {
        container.synchronize().resolve(Service.self)!
    }
}
