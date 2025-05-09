//
//  MealsEndpoint.swift
//  FitSenpai
//
//  Created by Mark Daquis on 5/6/25.
//


import Foundation
import CoreKit

enum MealsEndpoint {
    case generateMealsDemo(_ params: ParameterProtocol)
}

extension MealsEndpoint: NetworkEndpoint {
    
    var path: String {
        switch self {
        case .generateMealsDemo:
            return "/meals/demo"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .generateMealsDemo: .post
        }
    }
    
    var headers: [String: String]? {
        var headers = ["Content-Type": "application/json"]
        switch self {
        default:
            // Add authorization header for protected endpoints
            if let token = NetworkSession.shared.accessToken {
                headers["Authorization"] = "Bearer \(token)"
            }
        }
        return headers
    }
    
    var body: [String: Any]? {
        switch self {
        case let .generateMealsDemo(params):
            return params.toDictionary()
        }
    }
    
    var queryItems: [URLQueryItem]? {
        nil // No query parameters needed for auth endpoints
    }
}
