//
//  VerifyOTPUseCaseProtocol.swift
//  FitSenpai
//
//  Created by Mark Daquis on 7/4/25.
//


import Foundation
import CoreKit

protocol VerifyOTPUseCaseProtocol {
    func execute(email: String, token: String) async throws
}

final class VerifyOTPUseCase: VerifyOTPUseCaseProtocol {
    // MARK: - Dependencies
    @Inject private var repository: AuthRepositoryProtocol
    
    func execute(email: String, token: String) async throws {
        return try await repository.verifyOTP(email: email, token: token)
    }
}
