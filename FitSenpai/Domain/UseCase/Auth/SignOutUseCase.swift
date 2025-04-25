//
//  SigninUseCaseProtocol.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/5/25.
//

import Foundation
import CoreKit

protocol SignOutUseCaseProtocol {
    func execute() async throws
}

final class SignOutUseCase: SignOutUseCaseProtocol {
    
    // MARK: - Dependencies
    @Inject private var authRepository: AuthRepositoryProtocol
    
    func execute() async throws {
        return try await authRepository.signOut()
    }
}
