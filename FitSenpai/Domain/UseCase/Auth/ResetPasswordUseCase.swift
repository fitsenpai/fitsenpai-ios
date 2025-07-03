//
//  ResetPasswordUseCaseProtocol.swift
//  FitSenpai
//
//  Created by Mark Daquis on 7/4/25.
//


import Foundation
import CoreKit

protocol ResetPasswordUseCaseProtocol {
    func execute(password: String) async throws
}

final class ResetPasswordUseCase: ResetPasswordUseCaseProtocol {
    // MARK: - Dependencies
    @Inject private var repository: AuthRepositoryProtocol
    
    func execute(password: String) async throws {
        return try await repository.resetPassword(password: password)
    }
}
