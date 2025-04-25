//
//  UserRepository.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/23/25.
//

import Foundation
import CoreKit

final class UserRepository: UserRepositoryProtocol {
    
    // MARK: - Dependencies
    @Inject private var remoteDataSource: UserDataSourceProtocol
    
    func getUser() async throws -> FSUser {
        let response = try await remoteDataSource.getUser()
        
        guard let user = response.toDomain() else {
            throw AuthRepositoryError.missingUser
        }
        
        return user
    }
    
    func getUserProfile() async throws -> FitnessProfile {
        return try await remoteDataSource.getUserProfile().toDomain()
    }
    
    func deleteAccount(reason: String) async throws {
        try await remoteDataSource.deleteAccount(reason: reason)
        AppSession.shared.clearTokens()
    }
}
