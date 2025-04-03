//
//  AuthRepository.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/3/25.
//

import Foundation

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
        let user = FSUser(fromResponse: response.schema.user)
        let session = response.schema.session.toDomain()
        
        guard let accessToken = session.accessToken else {
            throw AuthRepositoryError.missingAccessToken
        }
        
        guard let refreshToken = session.refreshToken else {
            throw AuthRepositoryError.missingRefreshToken
        }
        
        AuthManager.shared.setTokens(accessToken: accessToken,
                                   refreshToken: refreshToken)
        return (user, session)
    }
    
    func signUp(name: String, email: String, password: String) async throws -> (FSUser, FSSession) {
        let response = try await remoteDataSource.signUp(name: name, email: email, password: password)
        let user = FSUser(fromResponse: response.schema.user)
        let session = response.schema.session.toDomain()
        
        guard let accessToken = session.accessToken else {
            throw AuthRepositoryError.missingAccessToken
        }
        
        guard let refreshToken = session.refreshToken else {
            throw AuthRepositoryError.missingRefreshToken
        }
        
        AuthManager.shared.setTokens(accessToken: accessToken,
                                   refreshToken: refreshToken)
        return (user, session)
    }
    
    func signInWithApple() async throws -> (FSUser, FSSession) {
        // TODO: Implement Apple Sign In
        throw NSError(domain: "AuthRepository", code: -1, userInfo: [NSLocalizedDescriptionKey: "Apple Sign In not implemented"])
    }
    
    func signInWithGoogle() async throws -> (FSUser, FSSession) {
        // TODO: Implement Google Sign In
        throw NSError(domain: "AuthRepository", code: -1, userInfo: [NSLocalizedDescriptionKey: "Google Sign In not implemented"])
    }
    
    func signOut() async throws {
        try await remoteDataSource.signOut()
        AuthManager.shared.clearTokens()
    }
    
    func sendPasswordResetEmail(to email: String) async throws {
        try await remoteDataSource.sendPasswordResetEmail(to: email)
    }
    
    func changePassword(currentPassword: String, newPassword: String) async throws {
        try await remoteDataSource.changePassword(currentPassword: currentPassword, newPassword: newPassword)
    }
    
    func deleteAccount(reason: String) async throws {
        try await remoteDataSource.deleteAccount(reason: reason)
        AuthManager.shared.clearTokens()
    }
}
