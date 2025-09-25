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
    case signInWithApple(user: String)
    case signInWithGoogle
    case getAuthCallback(code: String)
    case getUserAuth
    case resetPassword(password: String)
    case forgotPassword(email: String)
    case deleteAccount(feedback: String)
    case verifyOTP(email: String, token: String)
    case getAuthUrl(provider: String)
    case exchangeCode(code: String)
    
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
        case .getAuthCallback:
            return "/auth/mobile/callback"
        case .signInWithGoogle:
            return "/auth/mobile/google"
        case .resetPassword:
            return "/auth/reset-password"
        case .forgotPassword:
            return "/auth/forgot-password"
        case .getUserAuth, .deleteAccount:
            return "/auth/me"
        case .verifyOTP:
            return "/auth/verify-otp"
        case .getAuthUrl(let provider):
            return "/auth/mobile/\(provider)"
        case .exchangeCode:
            return "/auth/mobile/exchange"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .signIn, .signUp, .signOut, .resetPassword, .forgotPassword, .verifyOTP:
            return .post
        case .getUserAuth, .signInWithGoogle, .signInWithApple, .getAuthCallback, .getAuthUrl, .exchangeCode:
            return .get
        case .deleteAccount:
            return .delete
        }
    }
    
    var headers: [String: String]? {
        var headers = ["Content-Type": "application/json"]
        switch self {
        case .signIn, .signUp, .resetPassword, .signInWithGoogle, .signInWithApple, .verifyOTP, .getAuthUrl:
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
            return ["name": name, "email": email, "password": password]
        case let .resetPassword(password):
            return ["password": password]
        case let .forgotPassword(email):
            return ["email": email]
        case let .deleteAccount(feedback):
            return ["feedback": feedback]
        case let .verifyOTP(email, token):
            return ["email": email, "token": token]
        case let .exchangeCode(code):
            return ["code": code]
        default:
            return nil
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .getAuthCallback(let code):
            return [URLQueryItem(name: "code", value: code)]
        default:
            return nil
        }
    }
    
    var isLoggingEnabled: Bool {
        true
    }
}
