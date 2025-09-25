//
//  SigninUseCase.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/3/25.
//

import Foundation
import CoreKit

protocol SigninUseCaseProtocol {
    func execute(email: String, password: String) async throws -> (FSUser, FSSession)
    func executeWithApple(user: String) async throws -> (FSUser, FSSession)
    func executeWithGoogle() async throws -> String
    func executeWithCallback(code: String) async throws -> AuthCallbackResponse
    func execute(with provider: AuthProvider) async throws -> String
}

final class SigninUseCase: SigninUseCaseProtocol {
    // MARK: - Dependencies
    @Inject private var authRepository: AuthRepositoryProtocol
    
    // MARK: - Methods
    func execute(email: String, password: String) async throws -> (FSUser, FSSession) {
        return try await authRepository.signIn(email: email, password: password)
    }
    
    func executeWithApple(user: String) async throws -> (FSUser, FSSession) {
        return try await authRepository.signInWithApple(user: user)
    }
    
    func executeWithGoogle() async throws -> String {
        return try await authRepository.signInWithGoogle()
    }
    
    func executeWithCallback(code: String) async throws -> AuthCallbackResponse {
        return try await authRepository.getAuthCallback(code: code)
    }
    
    func execute(with provider: AuthProvider) async throws -> String {
        return try await authRepository.getAuthUrl(provider: provider)
    }
}
