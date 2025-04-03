//
//  AuthRemoteDataSource.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/3/25.
//

import Foundation

protocol AuthDataSourceProtocol {
    func signIn(email: String, password: String) async throws -> AuthResponseDTO
    func signUp(name: String, email: String, password: String) async throws -> AuthResponseDTO
    func signOut() async throws
    func sendPasswordResetEmail(to email: String) async throws
    func changePassword(currentPassword: String, newPassword: String) async throws
    func deleteAccount(reason: String) async throws
}

final class AuthRemoteDataSource: AuthDataSourceProtocol {
    
    // MARK: - Dependencies
    @Inject(key: .auth)
    private var networkService: NetworkService<AuthEndpoint>
    
    // MARK: - Auth API Calls
    
    func signIn(email: String, password: String) async throws -> AuthResponseDTO {
        return try await networkService.request(.signIn(email: email, password: password))
    }
    
    func signUp(name: String, email: String, password: String) async throws -> AuthResponseDTO {
        return try await networkService.request(.signUp(name: name, email: email, password: password))
    }
    
    func signOut() async throws {
        try await networkService.request(.signOut)
    }
    
    func sendPasswordResetEmail(to email: String) async throws {
        try await networkService.request(.resetPassword(email: email))
    }
    
    func changePassword(currentPassword: String, newPassword: String) async throws {
        try await networkService.request(.changePassword(currentPassword: currentPassword, newPassword: newPassword))
    }
    
    func deleteAccount(reason: String) async throws {
        try await networkService.request(.deleteAccount(reason: reason))
    }
}
