//
//  LoginViewModel.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/27/24.
//

import Foundation
import SwiftUI

@MainActor
class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let loginUseCase: LoginUseCaseProtocol

    init(loginUseCase: LoginUseCaseProtocol) {
        self.loginUseCase = loginUseCase
    }

    func login() async -> Bool {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Email and password cannot be empty."
            return false
        }

        isLoading = true
        errorMessage = nil
        
        defer { isLoading = false }
        
        do {
            let session = try await loginUseCase.execute(email: email, password: password)
            print("Login successful: \(session)")
            
            AuthManager.shared.setTokens(accessToken: session.accessToken, refreshToken: session.refreshToken)
            return true
            
        } catch {
            errorMessage = error.localizedDescription
            print("Error during login: \(error.localizedDescription)")
            return false
        }
    }
}
