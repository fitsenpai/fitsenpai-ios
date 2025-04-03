//
//  AuthRepositoryProtocol.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/3/25.
//


import Foundation

protocol AuthRepositoryProtocol {
    func signIn(email: String, password: String) async throws
    func signUp(name: String, email: String, password: String) async throws
    func signInWithApple() async throws
    func signInWithGoogle() async throws
    func signOut() async throws
    func sendPasswordResetEmail(to email: String) async throws
    func changePassword(currentPassword: String, newPassword: String) async throws
    func deleteAccount(reason: String) async throws
}

final class AuthRepository: AuthRepositoryProtocol {
    // MARK: - Types
    
    private struct EmptyResponse: Decodable {}
    
    private struct AuthSuccessResponse: Decodable {
        let accessToken: String
        let refreshToken: String
    }
    
    // MARK: - Dependencies
    
    @Inject private var networkService: NetworkServiceProtocol
    
    // MARK: - Authentication Methods
    
    func signIn(email: String, password: String) async throws {
        let response: AuthSuccessResponse = try await networkService.request(
            endpoint: AuthEndpoint.signIn(email: email, password: password)
        )
        AuthManager.shared.setTokens(
            accessToken: response.accessToken,
            refreshToken: response.refreshToken
        )
    }
    
    func signUp(name: String, email: String, password: String) async throws {
        let response: AuthSuccessResponse = try await networkService.request(
            endpoint: AuthEndpoint.signUp(name: name, email: email, password: password)
        )
        AuthManager.shared.setTokens(
            accessToken: response.accessToken,
            refreshToken: response.refreshToken
        )
    }
    
    func signInWithApple() async throws {
        // Implement Apple Sign In
        throw AuthError.notImplemented
    }
    
    func signInWithGoogle() async throws {
        // Implement Google Sign In
        throw AuthError.notImplemented
    }
    
    func signOut() async throws {
        let _: EmptyResponse = try await networkService.request(endpoint: AuthEndpoint.signOut)
        AuthManager.shared.clearTokens()
    }
    
    func sendPasswordResetEmail(to email: String) async throws {
        let _: EmptyResponse = try await networkService.request(
            endpoint: AuthEndpoint.resetPassword(email: email)
        )
    }
    
    func changePassword(currentPassword: String, newPassword: String) async throws {
        let _: EmptyResponse = try await networkService.request(
            endpoint: AuthEndpoint.changePassword(
                currentPassword: currentPassword,
                newPassword: newPassword
            )
        )
    }
    
    func deleteAccount(reason: String) async throws {
        let _: EmptyResponse = try await networkService.request(
            endpoint: AuthEndpoint.deleteAccount(reason: reason)
        )
        AuthManager.shared.clearTokens()
    }
}

// MARK: - Errors

enum AuthError: LocalizedError {
    case notImplemented
    case invalidCredentials
    case emailAlreadyInUse
    case weakPassword
    
    var errorDescription: String? {
        switch self {
        case .notImplemented:
            return "This feature is not yet implemented"
        case .invalidCredentials:
            return "Invalid email or password"
        case .emailAlreadyInUse:
            return "This email is already registered"
        case .weakPassword:
            return "Password must be at least 8 characters"
        }
    }
}
