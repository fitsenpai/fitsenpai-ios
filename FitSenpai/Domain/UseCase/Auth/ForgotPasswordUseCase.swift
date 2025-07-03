//
//  ForgotPasswordUseCaseProtocol.swift
//  FitSenpai
//
//  Created by Mark Daquis on 7/4/25.
//


import Foundation
import CoreKit

protocol ForgotPasswordUseCaseProtocol {
    func execute(email: String) async throws
}

final class ForgotPasswordUseCase: ForgotPasswordUseCaseProtocol {
    // MARK: - Dependencies
    @Inject private var repository: AuthRepositoryProtocol
    
    func execute(email: String) async throws {
        return try await repository.forgotPasswod(email: email)
    }
}
