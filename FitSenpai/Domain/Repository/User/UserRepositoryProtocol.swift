//
//  UserRepositoryProtocol.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/23/25.
//

import Foundation

protocol UserRepositoryProtocol {
    func getUser() async throws -> FSUser
    func getUserProfile() async throws -> UserProfile
    func deleteAccount(reason: String) async throws
    func saveUserProfile(_ userProfile: UserProfile) async throws -> UserProfile?
}
