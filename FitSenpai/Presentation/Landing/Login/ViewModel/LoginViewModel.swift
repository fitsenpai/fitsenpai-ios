//
//  LoginViewModel.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/27/24.
//

import Foundation
import SwiftUI
import AuthenticationServices
import CoreKit

@MainActor
class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var viewState: ViewState = .idle
    @Published var errorMessage: String?
    @Published var showForgotPassword: Bool = false
    @Published var shouldLogin: Bool = false
    
    @Inject private var signinUseCase: SigninUseCaseProtocol
    
    private let appleSignInManager = AppleSignInManager()

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
            NetworkSession.shared.setTokens(accessToken: session.accessToken,
                                         refreshToken: session.refreshToken)
            return true
        } catch {
            errorMessage = error.localizedDescription
            print("Error during login: \(error.localizedDescription)")
            return false
        }
    }
    
    func loginWithApple() {
        viewState = .loading
        errorMessage = nil
        
        appleSignInManager.signIn { [weak self] result in
            switch result {
            case .success(let authorization):
                self?.handleSuccessfulLogin(with: authorization)
            case .failure(let error):
                self?.handleLoginError(with: error)
            }
            self?.viewState = .idle
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
    
    private func handleSuccessfulLogin(with authorization: ASAuthorization) {
          if let userCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
              print(userCredential.user)
              
              if userCredential.authorizedScopes.contains(.fullName) {
                  print(userCredential.fullName?.givenName ?? "No given name")
              }
              
              if userCredential.authorizedScopes.contains(.email) {
                  print(userCredential.email ?? "No email")
              }
              shouldLogin = true

              // MARK: TODO
//              Task { @MainActor in
//                  do {
//                    
//                      let (_, _) = try await signinUseCase.executeWithApple(user: userCredential.user)
//                      shouldLogin = true
//                  } catch {
//                      errorMessage = error.localizedDescription
//                      print("Error during Apple login: \(error.localizedDescription)")
//                  }
//              }
          }
      }
      
      private func handleLoginError(with error: Error) {
          print("Could not authenticate: \(error.localizedDescription)")
      }
}
