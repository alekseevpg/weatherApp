//
//  HttpMethod.swift
//  WeatherApp
//
//  Created by alekseevpg on 13.08.2023.
//

import Foundation

enum HttpMethod<Body> {
    case get
    case post(Body)
    case patch(Body)
    case put(Body)
    case head
    case delete
}

extension HttpMethod {
    var method: String {
        switch self {
        case .get: return "GET"
        case .post: return "POST"
        case .patch: return "PATCH"
        case .head: return "HEAD"
        case .delete: return "DELETE"
        case .put: return "PUT"
        }
    }
}
