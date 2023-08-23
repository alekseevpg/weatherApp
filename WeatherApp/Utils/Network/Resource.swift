//
//  Resource.swift
//  WeatherApp
//
//  Created by alekseevpg on 13.08.2023.
//

import Foundation

struct Resource<A> {
    var urlRequest: URLRequest
    let parse: (Data) throws -> A

    var url: URL {
        urlRequest.url!
    }
}

extension Resource: CustomStringConvertible {
    var description: String {
        "URL: \(urlRequest.httpMethod) \(urlRequest.url!)"
    }
}

extension Resource where A: Decodable {
    init(get url: URL, query: [(String, String)] = []) {
        self.urlRequest = URLRequest(url: url, query: query)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        self.parse = { data in
            return try JSONDecoder.weatherAppDecoder.decode(A.self, from: data)
        }
    }
}

private extension URLRequest {
    init(url: URL, query: [(String, String)]) {
        guard !query.isEmpty else {
            self.init(url: url)
            return
        }
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            log.error("Failed to create url components out of \(url), this should never happen")
            self.init(url: url)
            return
        }
        components.queryItems = (components.queryItems ?? []) + query.map { URLQueryItem(name: $0, value: $1) }
        guard let fullUrl = components.url else {
            log.error("Failed to create url out of \(query), this should never happen")
            self.init(url: url)
            return
        }
        self.init(url: fullUrl)
    }
}
