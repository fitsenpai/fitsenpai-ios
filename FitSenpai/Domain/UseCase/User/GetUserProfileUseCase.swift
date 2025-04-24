//
//  GetUserProfileUseCase.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/23/25.
//


import Foundation

protocol GetUserProfileUseCaseProtocol {
    func execute() async throws -> FitnessProfile
}

final class GetUserProfileUseCase: GetUserProfileUseCaseProtocol {
    // MARK: - Dependencies
    @Inject private var repository: UserRepositoryProtocol
    
    func execute() async throws -> FitnessProfile {
        return try await repository.getUserProfile()
    }
}
