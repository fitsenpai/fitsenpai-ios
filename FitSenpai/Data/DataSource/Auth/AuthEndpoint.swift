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
    case getCurrentUser
    case signInWithApple(user: String)
    case signInWithGoogle
}

extension AuthEndpoint: NetworkEndpoint {
    
    var path: String {
        switch self {
        case .signIn:
            return "/user/login"
        case .signUp:
            return "/user/register"
        case .signOut:
            return "/user/logout"
        case .resetPassword:
            return "/user/reset-password"
        case .changePassword:
            return "/user/change-password"
        case .deleteAccount:
            return "/user/delete-account"
        case .getCurrentUser:
            return "/user"
        case .signInWithApple:
            return "/user/signInWithApple"
        case .signInWithGoogle:
            return "/user/signInWithGoogle"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .signIn, .signUp, .signInWithGoogle, .signInWithApple:
            return .post
        case .signOut:
            return .post
        case .resetPassword:
            return .post
        case .changePassword:
            return .put
        case .deleteAccount:
            return .delete
        case .getCurrentUser:
            return .get
        }
    }
    
    var headers: [String: String]? {
        var headers = ["Content-Type": "application/json"]
        switch self {
        case .signIn, .signUp, .resetPassword, .signInWithGoogle, .signInWithApple:
            // No additional headers needed for public endpoints
            break
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
        default:
            return nil
        }
    }
    
    var queryItems: [URLQueryItem]? {
        nil // No query parameters needed for auth endpoints
    }
}
