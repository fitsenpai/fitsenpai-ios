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
import SafariServices
import UIKit
import Supabase

@MainActor
class LoginViewModel: NSObject, ObservableObject, ASWebAuthenticationPresentationContextProviding {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var viewState: ViewState = .idle
    @Published var errorMessage: String?
    @Published var showForgotPassword: Bool = false
    @Published var shouldLogin: Bool = false
    
    /// Use case for fetching the current user from a data source (e.g., Supabase).
    @Inject private var getUserUseCase: GetUserAuthUseCaseProtocol
    @Inject private var signinUseCase: SigninUseCaseProtocol
    @Inject private var getUserProfileUseCase: GetUserProfileUseCaseProtocol
    
    @AppState(\.loginMethod) var loginMethod: String?
    @AppState(\.didSubscribedWithoutUserID) var didSubscribedWithoutUserID: Bool
    
    private let appleSignInManager = AppleSignInManager()
    private var authSession: ASWebAuthenticationSession?
    private var networkSession = NetworkSession.shared
    
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
            networkSession.setTokens(accessToken: session.accessToken, refreshToken: session.refreshToken)
            loginMethod = LoginMethod.email.rawValue
            return true
        } catch {
            errorMessage = error.localizedDescription
            FSLogger.log("Error during login: \(error.localizedDescription)")
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
    
    private func handleSuccessfulLogin(with authorization: ASAuthorization) {
        if let userCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            FSLogger.log("Apple User ID: \(userCredential.user)")
              
            if userCredential.authorizedScopes.contains(.fullName) {
                FSLogger.log("Apple User Full Name: \(userCredential.fullName?.givenName ?? "No given name")")
            }
              
            if userCredential.authorizedScopes.contains(.email) {
                FSLogger.log("Apple User Email: \(userCredential.email ?? "No email")")
            }
            
            Task { @MainActor in
                do {
                    let (user, _) = try await signinUseCase.executeWithApple(
                        user: userCredential.user
                    )
                    globalAppEnvObject.user = user
                    
                    loginMethod = LoginMethod.apple.rawValue
                    shouldLogin = true
                } catch {
                    errorMessage = error.localizedDescription
                    FSLogger
                        .log(
                            "Error during Apple login: \(error.localizedDescription)"
                        )
                }
            }
        }
    }
      
    private func handleLoginError(with error: Error) {
        FSLogger
            .log(
                "Could not authenticate with Apple: \(error.localizedDescription)"
            )
    }
    
    func loginWithGoogle() async {
        viewState = .loading
        errorMessage = nil
                
        do {
            let urlString = try await signinUseCase.executeWithGoogle()
            loginMethod = LoginMethod.google.rawValue
            
            guard let authURL = URL(string: urlString) else {
                viewState = .idle
                errorMessage = "Google Sign-in error: Invalid URL"
                return
            }
            
            let callbackScheme = "fitsenpai"

            authSession = ASWebAuthenticationSession(
                url: authURL,
                callbackURLScheme: callbackScheme,
                completionHandler: { [weak self] callbackURL, error in
                    guard let self = self else { return }
                    
                    if let error = error {
                        self.errorMessage = "Google Sign-In failed: \(error.localizedDescription)"
                        FSLogger
                            .log(self.errorMessage ?? "Google Sign-In error")
                        self.viewState = .idle
                        return
                    }
                    
                    guard let callbackURL = callbackURL else {
                        self.errorMessage = "Google Sign-In failed: No callback URL received."
                        FSLogger.log(self.errorMessage ?? "No callback URL")
                        self.viewState = .idle
                        return
                    }
                    
                    self.handleGoogleAuthCallback(callbackURL)
                })

            authSession?.presentationContextProvider = self
            authSession?.start()
            loginMethod = LoginMethod.google.rawValue
            
        } catch {
            errorMessage = error.localizedDescription
            print("Error during Google login: \(error.localizedDescription)")
        }

    }
    
    private func handleGoogleAuthCallback(_ url: URL) {
        guard let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems, let code = queryItems.first(where: { $0.name == "code" })?.value else {
            FSLogger.log("Google Auth Callback: Code not found in query parameters. URL: \(url.absoluteString)")
            self.viewState = .idle
            return
        }
        
        Task { @MainActor in
            do {
                let session = try await signinUseCase.executeWithGoogleCallback(code: code)
                networkSession.setTokens(accessToken: session.token, refreshToken: session.refreshToken)
                loginMethod = LoginMethod.google.rawValue
                await getCurrentUser()
                self.viewState = .idle
            } catch {
                networkSession.clearTokens()
                self.viewState = .idle
                self.errorMessage = "Google Sign-In failed: \(error.localizedDescription)"
            }
        }
    }   
    
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first(where: { $0.isKeyWindow }) else {
            FSLogger.log("Could not find key window for ASWebAuthenticationSession. Returning a new UIWindow().")
            return UIWindow()
        }
        return window
    }
    
    /// Retrieves the currently authenticated user and updates the global environment.
    func getCurrentUser() async {
        do {
            async let profileData =  self.getUserProfileUseCase.execute()
            async let userData = self.getUserUseCase.execute()
            
            let _ = try await profileData
            let user = try await userData
            
            didSubscribedWithoutUserID = false
            shouldLogin = true
            let userId = user.id.uuidString
            SuperwallManager.shared.userId = userId
            SuperwallManager.shared.identifyUser(with: userId)
            loginMethod = LoginMethod.google.rawValue
        } catch {
            networkSession.setTokens(accessToken: "", refreshToken: "")
            FSLogger.log("Login error: \(error.localizedDescription)")
            self.errorMessage = "Google Sign-In failed: No profile found."
        }
    }
}
