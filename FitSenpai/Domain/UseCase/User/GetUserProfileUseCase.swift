//
//  GetUserProfileUseCase.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/23/25.
//


import Foundation
import CoreKit

protocol GetUserProfileUseCaseProtocol {
    func execute() async throws -> UserProfile
}

final class GetUserProfileUseCase: GetUserProfileUseCaseProtocol {
    // MARK: - Dependencies
    @Inject private var repository: UserRepositoryProtocol
    
    func execute() async throws -> UserProfile {
        return try await repository.getUserProfile()
    }
}
