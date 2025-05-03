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
    
    @Inject(key: "profileStore") private var profileStore: ProfileDataStore
    
    @AppState(\.trialStartDate) private var trialStartDate
    
    
    func getUser() async throws -> FSUser {
        let response = try await remoteDataSource.getUser()
        
        guard let user = response.toDomain() else {
            throw AuthRepositoryError.missingUser
        }
        
        return user
    }
    
    func getUserProfile() async throws -> UserProfile {
        if trialStartDate != nil, let profileEntity = profileStore.getCurrentProfile() {
            return profileEntity.toDomain()
        }
        return try await remoteDataSource.getUserProfile().toDomain()
    }
    
    func saveUserProfile(_ userProfile: UserProfile) async throws -> UserProfile? {
        return profileStore.addProfile(userProfile.toEntity())?.toDomain()
    }
    
    func deleteAccount(reason: String) async throws {
        try await remoteDataSource.deleteAccount(reason: reason)
        NetworkSession.shared.clearTokens()
    }
}
