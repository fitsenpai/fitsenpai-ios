//
//  UserEndpoint.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/23/25.
//

import Foundation
import CoreKit

enum UserEndpoint {
    case getUser
    case getUserProfile
    case createUserProfile(_ params: ParameterProtocol)
    case updateUserProfile(_ params: ParameterProtocol)
    case deleteAccount(reason: String)
}

extension UserEndpoint: NetworkEndpoint {
    
    var path: String {
        switch self {
        case .getUser:
            return "/users/me"
        case .getUserProfile, .updateUserProfile, .createUserProfile:
            return "/profile"
        case .deleteAccount:
            return "/user/delete-account"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getUser, .getUserProfile: .get
        case .createUserProfile: .post
        case .updateUserProfile: .patch
        case .deleteAccount: .delete
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
        case let .updateUserProfile(params), let .createUserProfile(params):
            return params.toDictionary()
        case let .deleteAccount(reason):
            return ["reason": reason]
        default:
            return nil
        }
    }
    
    var queryItems: [URLQueryItem]? {
        nil // No query parameters needed for auth endpoints
    }
}
