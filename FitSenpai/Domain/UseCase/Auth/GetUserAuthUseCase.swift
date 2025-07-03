//
//  GetUserAuthUseCase.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/3/25.
//

import Foundation
import CoreKit

protocol GetUserAuthUseCaseProtocol {
    func execute() async throws -> FSUser
}

final class GetUserAuthUseCase: GetUserAuthUseCaseProtocol {
    // MARK: - Dependencies
    @Inject private var repository: AuthRepositoryProtocol
    
    func execute() async throws -> FSUser {
        return try await repository.getUserAuth()
    }
}
