//
//  AuthEndpoint.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/3/25.
//


import Foundation
import CoreKit

enum AuthEndpoint {
    case signIn(email: String, password: String)
    case signUp(name: String, email: String, password: String)
    case signOut
    case resetPassword(email: String)
    case changePassword(currentPassword: String, newPassword: String)
    case signInWithApple(user: String)
    case signInWithGoogle
    case getLoginCallback(code: String)
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
        case .signInWithApple:
            return "/auth/mobile/apple"
        case .getLoginCallback:
            return "/auth/mobile/callback"
        case .signInWithGoogle:
            return "/auth/mobile/google"
        case .resetPassword:
            return "/user/reset-password"
        case .changePassword:
            return "/user/change-password"
            
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .signIn, .signUp, .signOut, .resetPassword:
            return .post
        case .changePassword:
            return .put
        case .signInWithGoogle, .signInWithApple, .getLoginCallback:
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
            if let token = NetworkSession.shared.accessToken {
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
        default:
            return nil
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .getLoginCallback(let code):
            return [URLQueryItem(name: "code", value: code)]
        default:
            return nil
        }
    }
}
