//
//  WorkoutEndpoint.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/23/25.
//

import Foundation
import CoreKit

enum WorkoutEndpoint {
    case getWorkoutPlan
    case generateWorkoutPlan(_ params: ParameterProtocol)
    case regenerateWorkoutPlan(_ params: ParameterProtocol)
    case generateWorkoutDemo(_ params: ParameterProtocol)
    case updateWorkoutRoutine(_ params: ParameterProtocol)
}

extension WorkoutEndpoint: NetworkEndpoint {
    
    var path: String {
        switch self {
        case .getWorkoutPlan, .generateWorkoutPlan, .regenerateWorkoutPlan: "/workouts"
        case .generateWorkoutDemo: "/workouts/demo"
        case .updateWorkoutRoutine: "/workouts/routines/toggle-completed"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getWorkoutPlan: .get
        case .generateWorkoutDemo, .generateWorkoutPlan: .post
        case .regenerateWorkoutPlan, .updateWorkoutRoutine: .patch
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
        case .generateWorkoutDemo(let params), .regenerateWorkoutPlan(let params), .generateWorkoutPlan(let params), .updateWorkoutRoutine(let params):
            return params.toDictionary()
        default:
            return nil
        }
    }
    
    var queryItems: [URLQueryItem]? {
        nil // No query parameters needed for auth endpoints
    }
}
