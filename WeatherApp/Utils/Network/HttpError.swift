//
//  HttpError.swift
//  WeatherApp
//
//  Created by Pavel Alekseev.
//  based on https://talk.objc.io/episodes/S01E133-tiny-networking-library-revisited
//

import Foundation

enum HttpError: LocalizedError {
    case invalidResponse
    case invalidStatusCode(code: Int)
}
