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
        }
    }
}

final class AuthRepository: AuthRepositoryProtocol {
    
    // MARK: - Dependencies
    @Inject private var remoteDataSource: AuthDataSourceProtocol

    // MARK: - Authentication Methods
    
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
    
    func signInWithGoogle() async throws -> (FSUser, FSSession) {
        let response = try await remoteDataSource.signInWithGoogle()
        guard let user = response.user?.toDomain() else {
            throw AuthRepositoryError.missingUser
        }
        
        guard let session = response.session?.toDomain() else {
            throw AuthRepositoryError.invalidSession
        }
        
        return (user, session)}
    
    func signOut() async throws {
        try await remoteDataSource.signOut()
        AppSession.shared.clearTokens()
    }
    
    func sendPasswordResetEmail(to email: String) async throws {
        try await remoteDataSource.sendPasswordResetEmail(to: email)
    }
    
    func changePassword(currentPassword: String, newPassword: String) async throws {
        try await remoteDataSource.changePassword(currentPassword: currentPassword, newPassword: newPassword)
    }
}
