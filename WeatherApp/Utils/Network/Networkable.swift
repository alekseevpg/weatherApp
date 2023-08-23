//
//  Backend.swift
//  WeatherApp
//
//  Created by Pavel Alekseev.
//

import Foundation
import SwiftUI

protocol Networking {
    func load<T>(_ resource: Resource<T>) async throws -> T
}

final class Networkable: Networking {
    let session: URLSession = URLSession(configuration: .noCache)

    func load<T>(_ resource: Resource<T>) async throws -> T {
        try await load(resource, repeatCount: 1)
    }

    private func load<T>(_ resource: Resource<T>, repeatCount: Int) async throws -> T {
        let request = resource.urlRequest
        do {
            let data = try await self.session.wrappedTokenRefreshingDataTask(with: request)
            return try resource.parse(data)
        } catch let error as BackendError {
            let message = """
            Request failed with traceId
            \n
            Request: \(request)
            Body: \(String(decoding: request.httpBody ?? Data(), as: UTF8.self))
            \n
            Response: \(error)
            """
            log.error(message)
            let backendError = await mapStatusCodeError(error)
            if repeatCount <= 3 {
                try await Task.sleep(s: TimeInterval(repeatCount * 5))
                return try await load(resource, repeatCount: repeatCount + 1)
            } else {
                throw backendError
            }
        } catch {
            let message = """
            Request failed with traceId
            \n
            Request: \(request)
            \n
            Response: \(error)
            """
            log.error(message)
            if let backendError = mapURLErrors(error) {
                throw backendError
            } else {
                throw BackendError.inlineError(error)
            }
        }
    }

    private func mapStatusCodeError(_ error: BackendError) async -> BackendError {
        guard case .invalidHTTPStatusCode(let statusCode, let url, _) = error else {
            return error
        }
        switch statusCode {
        case 404:
            log.warning("could not load \(url): 404")
            return .notFound
        case 500:
            log.warning("could not load \(url): 500")
            return .sadServer
        default:
            return error
        }
    }

    private func mapURLErrors(_ error: Error) -> BackendError? {
        if let urlError = error as? URLError {
            if urlError.code == URLError.notConnectedToInternet || urlError.code == URLError.timedOut {
                return .badNetwork
            } else {
                return .urlError(urlError)
            }
        } else {
            return nil
        }
    }
}

extension URLSession {
    fileprivate func wrappedTokenRefreshingDataTask(with request: URLRequest) async throws -> Data {
        return try await withCheckedThrowingContinuation { continuation in

            log.debug("🌎 \(request.httpMethod.flatMap({ loggingTerm(for: $0) })) \(request.url)")

            dataTask(with: request) { data, response, error in
                if let error = error {
                    log.warning("could not load \(request.url): \(error)")
                    continuation.resume(throwing: error)
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    log.warning("could not load \(request.url): response not http")
                    continuation.resume(throwing: BackendError.noData)
                    return
                }

                switch httpResponse.statusCode {
                case 200...299:
                    break
                default:
                    let message: String
                    if let data = data,
                       let msg = String(data: data, encoding: .utf8) {
                        message = msg
                    } else {
                        message = "<no data>"
                    }
                    log.warning("could not load \(request.url): invalid code \(httpResponse.statusCode) \(message as NSString)")
                    continuation.resume(throwing: BackendError.invalidHTTPStatusCode(code: httpResponse.statusCode, url: request.url!, message: message))
                    return
                }

                guard let data = data else {
                    continuation.resume(throwing: BackendError.noData)
                    return
                }

                continuation.resume(returning: data)
            }.resume()
        }
    }

    private func loggingTerm(for httpMethod: String) -> String {
        switch httpMethod {
        case "GET":
            return "Getting"
        case "POST":
            return "Posting to"
        case "DELETE":
            return "Deleting"
        case "PUT":
            return "Putting"
        case "PATCH":
            return "Patching"
        default:
            return "Unknown call to"
        }
    }
}

extension URLSessionConfiguration {
    static var noCache: URLSessionConfiguration {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        return config
    }
}
