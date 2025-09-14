//
//  SinginAccountViewModel.swift
//  FitSenpai
//
//  Created by Mark Daquis on 9/13/25.
//

import Foundation
import CoreKit
import AuthenticationServices
import SafariServices
import UIKit

@MainActor
final class SignInAccountViewModel: NSObject, ObservableObject, HandlesErrors {
    @Published var viewState: ViewState = .idle
    @Published var didSignIn: Bool = false

    private var authSession: ASWebAuthenticationSession?
    
    // MARK: - UseCases
    /// Use case for fetching the current user from a data source (e.g., Supabase).
    @Inject private var getUserUseCase: GetUserAuthUseCaseProtocol
    @Inject private var signinUseCase: SigninUseCaseProtocol
    @Inject private var getUserProfileUseCase: GetUserProfileUseCaseProtocol
    @Inject private var createProfileUseCase: CreateProfileUseCaseProtocol
    
    @AppState(\.didSubscribedWithoutUserID) private var didSubscribedWithoutUserID: Bool
    
    let networkSession = NetworkSession.shared
    

}

extension SignInAccountViewModel: ASWebAuthenticationPresentationContextProviding {
    
    func loginWithGoogle() async {
        viewState = .loading
                
        do {
            let urlString = try await signinUseCase.executeWithGoogle()
            
            guard let authURL = URL(string: urlString) else {
                return
            }
            
            let callbackScheme = "fitsenpai"

            authSession = ASWebAuthenticationSession(
                url: authURL,
                callbackURLScheme: callbackScheme,
                completionHandler: { [weak self] callbackURL, error in
                    guard let self = self else { return }
                    
                    if let error {
                        ToastManager.shared.showError(ValidationError.invalid(error).localizedDescription)
                        viewState = .idle
                        return
                    }
                    
                    guard let callbackURL else {
                        let error = ValidationError.noCallbackURL
                        ToastManager.shared.showError(error.localizedDescription)
                        viewState = .idle
                        return
                    }
                    
                    self.handleGoogleAuthCallback(callbackURL)
                })

            authSession?.presentationContextProvider = self
            authSession?.start()
        } catch {
            viewState = .idle
            ToastManager.shared.showError("Error during Google login: \(error.localizedDescription)")
        }

    }
    
    private func handleGoogleAuthCallback(_ url: URL) {
        guard let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems, let code = queryItems.first(where: { $0.name == "code" })?.value else {
            ToastManager.shared.showError("Google Auth Callback: Code not found in query parameters. URL: \(url.absoluteString)")
            viewState = .idle
            return
        }
        
        Task { @MainActor in
            do {
                let session = try await signinUseCase.executeWithGoogleCallback(code: code)
                networkSession.setTokens(accessToken: session.token, refreshToken: session.refreshToken)
        
                try await createProfileUseCase.execute()
                let user = try await getUserUseCase.execute()
                SuperwallManager.shared.identifyUser(with: user.id.uuidString)
                didSubscribedWithoutUserID = false
                didSignIn = true
                viewState = .idle
            } catch {
                let error = ValidationError.profileAlreadyExists
                ToastManager.shared.showError(error.localizedDescription)
                networkSession.clearTokens()
                viewState = .idle
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
    
    private enum ValidationError: Error {
        case noCallbackURL
        case codeNotFound
        case profileAlreadyExists
        case invalid(_ error: Error)
        
        var localizedDescription: String {
            switch self {
            case .noCallbackURL:
                return "No callback URL provided."
            case .codeNotFound:
                return "Code not found in callback URL query parameters."
            case .profileAlreadyExists:
                return "A profile already exists for this google account. Please try with different account."
            case .invalid(let error):
                return error.localizedDescription
            }
        }
    }
}
