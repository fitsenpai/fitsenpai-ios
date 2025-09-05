//
//  WeightsEndpoint.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/23/25.
//

import Foundation
import CoreKit

enum WeightsEndpoint {
    case getWeights
    case createWeights(_ params: ParameterProtocol)
    case getBMI(id: String)
    case getBMIDemo(_ params: ParameterProtocol)
}

extension WeightsEndpoint: NetworkEndpoint {
    
    var path: String {
        switch self {
        case .getWeights, .createWeights:
            return "/weights"
        case .getBMI:
            return "/bmi"
        case .getBMIDemo:
            return "/bmi/guest"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getWeights, .getBMI : .get
        case .createWeights, .getBMIDemo: .post
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
        case .createWeights(let params), .getBMIDemo(let params):
            return params.toDictionary()
        default:
            return nil
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .getBMI(let id):
            return [URLQueryItem(name: "user_id", value: id)]
        default:
            return nil
        }
    }
}
