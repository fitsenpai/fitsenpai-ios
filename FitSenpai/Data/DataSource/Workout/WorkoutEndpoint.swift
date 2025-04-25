//
//  WorkoutEndpoint.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/23/25.
//

import Foundation

enum WorkoutEndpoint {
    case getWorkoutPlan
    case generateDemoWorkout(_ params: TrialWorkoutRequest)
}

extension WorkoutEndpoint: NetworkEndpoint {
    
    var path: String {
        switch self {
        case .getWorkoutPlan:
            return "/user/workout-plan"
        case .generateDemoWorkout:
            return "/guest/demo-workout"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getWorkoutPlan:
            return .get
        case .generateDemoWorkout:
            return .post
        }
    }
    
    var headers: [String: String]? {
        var headers = ["Content-Type": "application/json"]
        switch self {
        default:
            // Add authorization header for protected endpoints
            if let token = AppSession.shared.accessToken {
                headers["Authorization"] = "Bearer \(token)"
            }
        }
        return headers
    }
    
    var body: [String: Any]? {
        switch self {
        case let .generateDemoWorkout(params):
            return params.toDictionary()
        default:
            return nil
        }
    }
    
    var queryItems: [URLQueryItem]? {
        nil // No query parameters needed for auth endpoints
    }
}
