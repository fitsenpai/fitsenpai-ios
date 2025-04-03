//
//  AuthEndpoint.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/3/25.
//


import Foundation

enum AuthEndpoint {
    case signIn(email: String, password: String)
    case signUp(name: String, email: String, password: String)
    case signOut
    case resetPassword(email: String)
    case changePassword(currentPassword: String, newPassword: String)
    case deleteAccount(reason: String)
}

extension AuthEndpoint: NetworkEndpoint {
    
    var path: String {
        switch self {
        case .signIn:
            return "/auth/login"
        case .signUp:
            return "/auth/register"
        case .signOut:
            return "/auth/logout"
        case .resetPassword:
            return "/auth/reset-password"
        case .changePassword:
            return "/auth/change-password"
        case .deleteAccount:
            return "/auth/delete-account"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .signIn, .signUp:
            return .post
        case .signOut:
            return .post
        case .resetPassword:
            return .post
        case .changePassword:
            return .put
        case .deleteAccount:
            return .delete
        }
    }
    
    var headers: [String: String]? {
        var headers = ["Content-Type": "application/json"]
        switch self {
        case .signIn, .signUp, .resetPassword:
            // No additional headers needed for public endpoints
            break
        default:
            // Add authorization header for protected endpoints
            if let token = AuthManager.shared.accessToken {
                headers["Authorization"] = "Bearer \(token)"
            }
        }
        return headers
    }
    
    var body: [String: Any]? {
        switch self {
        case let .signIn(email, password):
            return ["email": email, "password": password]
        case let .signUp(name, email, password):
            return [
                "name": name,
                "email": email,
                "password": password
            ]
        case let .resetPassword(email):
            return ["email": email]
        case let .changePassword(currentPassword, newPassword):
            return [
                "current_password": currentPassword,
                "new_password": newPassword
            ]
        case let .deleteAccount(reason):
            return ["reason": reason]
        case .signOut:
            return nil
        }
    }
    
    var queryItems: [URLQueryItem]? {
        nil // No query parameters needed for auth endpoints
    }
    
    var cachePolicy: URLRequest.CachePolicy? {
        .reloadIgnoringLocalAndRemoteCacheData // Don't cache auth requests
    }
}
