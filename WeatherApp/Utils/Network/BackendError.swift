//
//  BackendError.swift
//  WeatherApp
//
//  Created by Pavel Alekseev.
//

import Foundation

enum BackendError: LocalizedError, Identifiable {
    var id: String {
        String(reflecting: self)
    }

    case sadServer
    case noData
    case invalidHTTPStatusCode(code: Int, url: URL, message: String)
    case urlError(URLError)
    case badNetwork
    case notFound
    case inlineError(Error)

    var errorTitle: String {
        switch self {
        case .sadServer:
            return "Sorry, server is sad at the moment :("
        case .noData:
            return "Sorry, server did not return any data :("
        case .badNetwork:
            return "Bad Network Connection"
        case .notFound:
            return "Requested url not found"
        case .inlineError(let error):
            return error.localizedDescription
        default:
            return "An error occured"
        }
    }

    var errorMessage: String {
        switch self {
        case .noData:
            return "Server coudn't send you back anything meaningful. Please contact developers with the steps to reproduce this issue."
        case .badNetwork, .notFound:
            return "We're having trouble connecting to servers, please make sure your network connection is working and then try again."
        case .sadServer:
            return "Please, retry later"
        case .invalidHTTPStatusCode(_, _, let message):
            if let jsonData = message.data(using: .utf8) {
                let serverErrorMessage = try? JSONDecoder().decode(ServerErrorMessage.self, from: jsonData)
                return serverErrorMessage?.detail ?? message
            }
            return message
        default:
            return localizedDescription
        }
    }

    private struct ServerErrorMessage: Codable {
        let detail: String
    }
}
