//
//  SubscriptionEndpoint.swift
//  FitSenpai
//
//  Created by Codex on 10/13/25.
//

import Foundation
import CoreKit

enum SubscriptionEndpoint {
    case getSubscription
}

extension SubscriptionEndpoint: NetworkEndpoint {
    var path: String {
        "/subscriptions"
    }
    
    var method: HTTPMethod {
        .get
    }
    
    var headers: [String: String]? {
        var headers = ["Content-Type": "application/json"]
        if let token = NetworkSession.shared.accessToken {
            headers["Authorization"] = "Bearer \(token)"
        }
        return headers
    }
    
    var body: [String: Any]? {
        nil
    }
    
    var queryItems: [URLQueryItem]? {
        nil
    }
}
