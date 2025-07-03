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
    case groceryToggleCompleted(_ params: ParameterProtocol)
}

extension GroceryEndpoint: NetworkEndpoint {
    
    var path: String {
        switch self {
        case .getGroceries: "/groceries"
        case .groceryToggleCompleted: "/groceries/items/toggle-completed"
            
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getGroceries: .get
        case .groceryToggleCompleted: .patch
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
        case .getGroceries:
            return nil
        case .groceryToggleCompleted(let params):
            return params.toDictionary()
        }
    }
    
    var queryItems: [URLQueryItem]? {
        nil // No query parameters needed for auth endpoints
    }
}

struct GroceryToggleParams: ParameterProtocol {
    let date: String
    let name: String
    let category: String
}
