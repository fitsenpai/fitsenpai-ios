//
//  MealsEndpoint.swift
//  FitSenpai
//
//  Created by Mark Daquis on 5/6/25.
//


import Foundation
import CoreKit

enum MealsEndpoint {
    case getMealPlan
    case generateMealPlan(_ params: ParameterProtocol)
    case regenerateMealPlan(_ params: ParameterProtocol)
    case generateMealsDemo(_ params: ParameterProtocol)
}

extension MealsEndpoint: NetworkEndpoint {
    
    var path: String {
        switch self {
        case .getMealPlan, .generateMealPlan, .regenerateMealPlan:
            return "/meals"
        case .generateMealsDemo:
            return "/meals/demo"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getMealPlan: .get
        case .generateMealsDemo, .generateMealPlan: .post
        case .regenerateMealPlan: .put
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
        case .generateMealPlan(let params), .regenerateMealPlan(let params), .generateMealsDemo(let params):
            return params.toDictionary()
        default:
            return nil
        }
    }
    
    var queryItems: [URLQueryItem]? {
        nil // No query parameters needed for auth endpoints
    }
}
