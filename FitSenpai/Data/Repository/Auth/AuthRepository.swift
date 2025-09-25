//
//  AuthRepository.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/3/25.
//

import Foundation
import CoreKit

enum AuthRepositoryError: LocalizedError {
    case invalidSession
    case missingAccessToken
    case missingRefreshToken
    case missingUser
    case invalidEmail
    
    var errorDescription: String? {
        switch self {
        case .invalidSession:
            return "Invalid session data received"
        case .missingAccessToken:
            return "Access token is missing"
        case .missingRefreshToken:
            return "Refresh token is missing"
        case .missingUser:
            return "User data is missing"
        case .invalidEmail:
            return "Invalid email address."
        }
    }
}

final class AuthRepository: AuthRepositoryProtocol {
    
    // MARK: - Dependencies
    @Inject private var remoteDataSource: AuthDataSourceProtocol

    // MARK: - Authentication Methods
    
    func getUserAuth() async throws -> FSUser {
        let response = try await remoteDataSource.getUserAuth()
        
        guard let user = response.toDomain() else {
            throw AuthRepositoryError.missingUser
        }
        
        return user
    }
    
    func signIn(email: String, password: String) async throws -> (FSUser, FSSession) {
        let response = try await remoteDataSource.signIn(email: email, password: password)
        
        guard let user = response.user?.toDomain() else {
            throw AuthRepositoryError.missingUser
        }
        
        guard let session = response.session?.toDomain() else {
            throw AuthRepositoryError.invalidSession
        }
        
        return (user, session)
    }
    
    func signUp(name: String, email: String, password: String) async throws -> (FSUser, FSSession) {
        let response = try await remoteDataSource.signUp(name: name, email: email, password: password)
       
        guard let user = response.user?.toDomain() else {
            throw AuthRepositoryError.missingUser
        }
        
        guard let session = response.session?.toDomain() else {
            throw AuthRepositoryError.invalidSession
        }
        
        return (user, session)
    }
    
    func signInWithApple(user: String) async throws -> (FSUser, FSSession) {
        let response = try await remoteDataSource.signInWithApple(user: user)
       
        guard let user = response.user?.toDomain() else {
            throw AuthRepositoryError.missingUser
        }
        
        guard let session = response.session?.toDomain() else {
            throw AuthRepositoryError.invalidSession
        }
        
        return (user, session)
    }
    
    func signInWithGoogle() async throws -> String {
        let response = try await remoteDataSource.signInWithGoogle()
        return response.url
    }
    
    func getAuthCallback(code: String) async throws -> AuthCallbackResponse {
        try await remoteDataSource.getLoginCallback(code: code)
    }
    
    func signOut() async throws {
        try await remoteDataSource.signOut()
        NetworkSession.shared.clearTokens()
    }
    
    func forgotPasswod(email: String) async throws {
        try await remoteDataSource.forgotPassword(email: email)
    }
    
    func resetPassword(password: String) async throws {
        try await remoteDataSource.resetPassword(password: password)
    }
    
    func verifyOTP(email: String, token: String) async throws {
        try await remoteDataSource.verifyOTP(email: email, token: token)
    }
    
    func deleteAccount(feedback: String) async throws {
        try await remoteDataSource.deleteAccount(feedback: feedback)
    }
    
    func getAuthUrl(provider: AuthProvider) async throws -> String {
        let response = try await remoteDataSource.getAuthUrl(provider: provider)
        return response.url
    }
    
    func exchangeCode(_ code: String) async throws -> AuthCallbackResponse {
        try await remoteDataSource.exchangeCode(code)
    }
}
