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

    func login() async {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Email and password cannot be empty."
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            let session = try await loginUseCase.execute(email: email, password: password)
            print("Login successful: \(session)")
            // Navigate to the main view after successful login
            DispatchQueue.main.async {
                if let windowScene = UIApplication.shared.connectedScenes
                    .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
                   let window = windowScene.windows.first(where: { $0.isKeyWindow }) {
                    AppLoader.shared.configure(window: window)
                    AppLoader.shared.presentMainViewController()
                }
            }
        } catch {
            errorMessage = error.localizedDescription
            print("Error during login: \(error.localizedDescription)")
        }

        isLoading = false
    }
}
