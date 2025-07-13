//
//  FeedbackEndpoint.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/3/25.
//


import Foundation
import CoreKit

enum FeedbackEndpoint {
    case sendFeedback(_ params: ParameterProtocol)
}

extension FeedbackEndpoint: NetworkEndpoint {
    
    var path: String {
        switch self {
        case .sendFeedback:
            return "/feedbacks"
        }
    }
    
    var method: HTTPMethod {
        return .post
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
        case .sendFeedback(let params):
            return params.toDictionary()
        }
    }
}
