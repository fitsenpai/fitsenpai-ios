//
//  GetCurrentSessionUseCase.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/3/25.
//

import Foundation
import CoreKit

protocol GetUserUseCaseProtocol {
    func execute() async throws -> FSUser
}

final class GetUserUseCase: GetUserUseCaseProtocol {
    // MARK: - Dependencies
    @Inject private var repository: UserRepositoryProtocol
    
    func execute() async throws -> FSUser {
        return try await repository.getUser()
    }
}
