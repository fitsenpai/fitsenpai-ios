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
    @Published var viewState: ViewState = .idle
    @Published var errorMessage: String?
    
    @Inject private var signinUseCase: SigninUseCaseProtocol

    func login() async -> Bool {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Email and password cannot be empty."
            return false
        }

        viewState = .loading
        errorMessage = nil
        
        defer { viewState = .idle }
        
        do {
            let (user, session) = try await signinUseCase.execute(email: email, password: password)
            globalAppEnvObject.user = user
            AuthManager.shared.setTokens(accessToken: session.accessToken,
                                         refreshToken: session.refreshToken)
            return true
        } catch {
            errorMessage = error.localizedDescription
            print("Error during login: \(error.localizedDescription)")
            return false
        }
    }
    
    func loginWithApple() async -> Bool {
        viewState = .loading
        errorMessage = nil
        
        defer { viewState = .idle }
        
        do {
            let (_, _) = try await signinUseCase.executeWithApple()
            return true
        } catch {
            errorMessage = error.localizedDescription
            print("Error during Apple login: \(error.localizedDescription)")
            return false
        }
    }
    
    func loginWithGoogle() async -> Bool {
        viewState = .loading
            errorMessage = nil
        
        defer { viewState = .idle }
        
        do {
            let (_, _) = try await signinUseCase.executeWithGoogle()
            return true
        } catch {
            errorMessage = error.localizedDescription
            print("Error during Google login: \(error.localizedDescription)")
            return false
        }
    }
}
