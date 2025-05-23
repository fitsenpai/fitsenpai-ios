//
//  GroceryEndpoint.swift
//  FitSenpai
//
//  Created by Mark Daquis on 5/16/25.
//


import Foundation
import CoreKit

enum GroceryEndpoint {
    case getGroceries
}

extension GroceryEndpoint: NetworkEndpoint {
    
    var path: String {
        switch self {
        case .getGroceries:
            return "/groceries"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getGroceries: .post
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
        return nil
    }
    
    var queryItems: [URLQueryItem]? {
        nil // No query parameters needed for auth endpoints
    }
}
