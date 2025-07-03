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
    
    @Inject private var profileStore: ProfileDataStore
    
    @AppState(\.trialStartDate) private var trialStartDate
    
    
    func getUserProfile() async throws -> UserProfile {
        if trialStartDate != nil, let profileEntity = profileStore.getCurrentProfile() {
            return profileEntity.toDomain()
        }
        return try await remoteDataSource.getUserProfile().toDomain()
    }
    
    func createUserProfile() async throws  {
        guard let profileEntity = profileStore.getCurrentProfile()?.toDomain() else { throw AuthRepositoryError.missingUser }
        try await remoteDataSource.createUserProfile(profileEntity.toRequestBody())
    }
    
    func saveUserProfile(_ userProfile: UserProfile) async throws -> UserProfile? {
        let profile = profileStore.addProfile(userProfile.toEntity())?.toDomain()
        if trialStartDate == nil, let requestBody = profile?.toRequestBody() {
            try await remoteDataSource.updateUserProfile(requestBody)
        }
        return profile
    }
    
    func deleteAccount(reason: String) async throws {
        try await remoteDataSource.deleteAccount(reason: reason)
        NetworkSession.shared.clearTokens()
    }
}
