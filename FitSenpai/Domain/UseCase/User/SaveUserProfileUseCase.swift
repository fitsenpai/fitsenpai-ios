//
//  SaveUserUseCaseProtocol.swift
//  FitSenpai
//
//  Created by Mark Daquis on 5/3/25.
//


//
//  GetCurrentSessionUseCase.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/3/25.
//

import Foundation
import CoreKit

protocol SaveUserProfileUseCaseProtocol {
    func execute(_ profile: UserProfile) async throws -> UserProfile?
}

final class SaveUserProfileUseCase: SaveUserProfileUseCaseProtocol {
    // MARK: - Dependencies
    @Inject private var repository: UserRepositoryProtocol
    
    func execute(_ profile: UserProfile) async throws -> UserProfile? {
        try await repository.saveUserProfile(profile)
    }
}
