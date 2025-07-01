//
//  UserDataSource.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/23/25.
//


import Foundation
import CoreKit

protocol UserDataSourceProtocol {
    func getUser() async throws -> UserDTO
    func getUserProfile() async throws -> UserProfileDTO
    func createUserProfile(_ params: WorkoutProfileRequest) async throws
    func updateUserProfile(_ params: WorkoutProfileRequest) async throws
    func deleteAccount(reason: String) async throws
}

final class UserDataSource: UserDataSourceProtocol {
   
    // MARK: - Dependencies
    @Inject(key: "user")
    private var networkService: NetworkService<UserEndpoint>
    
    // MARK: - Auth API Calls
    
    func getUser() async throws -> UserDTO {
        return try await networkService.request(.getUser)
    }
    
    func getUserProfile() async throws -> UserProfileDTO {
        return try await networkService.request(.getUserProfile)
    }
    
    func createUserProfile(_ params: WorkoutProfileRequest) async throws {
        try await networkService.request(.createUserProfile(params))
    }
    
    func updateUserProfile(_ params: WorkoutProfileRequest) async throws {
        try await networkService.request(.updateUserProfile(params))
    }
    
    func deleteAccount(reason: String) async throws {
        try await networkService.request(.deleteAccount(reason: reason))
    }
}
