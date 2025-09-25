//
//  AuthRemoteDataSource.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/3/25.
//

import Foundation
import CoreKit

protocol AuthDataSourceProtocol {
    func getUserAuth() async throws -> UserDTO 
    func signIn(email: String, password: String) async throws -> LoginResponse
    func signInWithApple(user: String) async throws -> LoginResponse
    func signInWithGoogle() async throws -> AuthMobileResponse
    func getAuthUrl(provider: AuthProvider) async throws -> AuthMobileResponse
    func signUp(name: String, email: String, password: String) async throws -> LoginResponse
    func signOut() async throws
    func getLoginCallback(code: String) async throws -> AuthCallbackResponse
    func forgotPassword(email: String) async throws
    func resetPassword(password: String) async throws
    func verifyOTP(email: String, token: String) async throws
    func deleteAccount(feedback: String) async throws
    func exchangeCode(_ code: String) async throws -> AuthCallbackResponse 
}

final class AuthDataSource: AuthDataSourceProtocol {
    
    // MARK: - Dependencies
    @Inject(key: "auth")
    private var networkService: NetworkService<AuthEndpoint>
    
    // MARK: - Auth API Calls
    
    func getUserAuth() async throws -> UserDTO {
        return try await networkService.request(.getUserAuth)
    }
    
    func signIn(email: String, password: String) async throws -> LoginResponse {
        return try await networkService.request(.signIn(email: email, password: password))
    }
    
    func getAuthUrl(provider: AuthProvider) async throws -> AuthMobileResponse {
        return try await networkService.request(.getAuthUrl(provider: provider.rawValue))
    }
    
    func signInWithApple(user: String) async throws -> LoginResponse {
        return try await networkService.request(.signInWithApple(user: user))
    }
    
    func signInWithGoogle() async throws -> AuthMobileResponse {
        return try await networkService.request(.signInWithGoogle)
    }
    
    func getLoginCallback(code: String) async throws -> AuthCallbackResponse {
        return try await networkService.request(.getAuthCallback(code: code))
    }
    
    func signUp(name: String, email: String, password: String) async throws -> LoginResponse {
        return try await networkService.request(.signUp(name: name, email: email, password: password))
    }
    
    func signOut() async throws {
        try await networkService.request(.signOut)
    }
    
    func forgotPassword(email: String) async throws {
        try await networkService.request(.forgotPassword(email: email))
    }
    
    func resetPassword(password: String) async throws {
        try await networkService.request(.resetPassword(password: password))
    }
    
    func verifyOTP(email: String, token: String) async throws {
        try await networkService.request(.verifyOTP(email: email, token: token))
    }
    
    func deleteAccount(feedback: String) async throws {
        try await networkService.request(.deleteAccount(feedback: feedback))
    }
    
    func exchangeCode(_ code: String) async throws -> AuthCallbackResponse {
        return try await networkService.request(.getAuthCallback(code: code))
    }
}
