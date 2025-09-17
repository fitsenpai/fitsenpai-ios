//
//  AppState.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/27/24.
//

import Foundation
import Supabase
import AuthenticationServices
import CoreKit
import SafariServices
import UIKit

/// A view model responsible for managing the global app state,
/// including user authentication and initialization logic.
@MainActor
class AppViewModel: NSObject, ObservableObject {
    // MARK: - Properties
    
    /// The authenticated user object, if available.
    @Published var user: FSUser?
    
    /// The authenticated user object, if available.
    @Published var userProfile: UserProfile?
    
    /// Indicates whether the user is currently logged in.
    @Published var authState: AppAuthState = .checkingAuth
    
    /// Represents the current view state of the app, used for loading indicators.
    @Published var viewState: ViewState = .loading
    
    /// Determines the current navigation destination during onboarding.
    @Published var authDestination: AuthNavDestination? = nil
    
    /// A flag indicating whether the user should be directed to the login screen.-
    @Published var shouldLogin: Bool = false
    
    /// A flag indicating whether the user should be directed to the sign in screen.
    @Published var shouldSignIn: Bool = false
    
    @Published var errorMessage: String?
    
    @Published var networkSession = NetworkSession.shared

    // MARK: - UseCases
    /// Use case for fetching the current user from a data source (e.g., Supabase).
    @Inject private var getUserUseCase: GetUserAuthUseCaseProtocol
    @Inject private var signinUseCase: SigninUseCaseProtocol
    @Inject private var getUserProfileUseCase: GetUserProfileUseCaseProtocol
    @Inject private var createProfileUseCase: CreateProfileUseCaseProtocol
    
    @AppState(\.loginMethod) var loginMethod: String?
    @AppState(\.didSubscribedWithoutUserID) private var didSubscribedWithoutUserID: Bool

    private let appleSignInManager = AppleSignInManager()
    private var authSession: ASWebAuthenticationSession?
        
    /// A flag indicating whether the user should be directed to the login screen.
    var isProduction: Bool {
        return EnvironmentManager.shared.value(for: .isProduction) ?? false
    }
    
    var isLoggedIn: Bool {
        return authState == .authenticated
    }

    /// Initializes the AppViewModel.
    ///
    /// This sets up dependencies and attempts to fetch the current user to determine
    /// the authentication state and access level.
    override init() {
        super.init()
        Task { @MainActor in
            // Register as login presenter
            SuperwallManager.shared.loginPresenter = self
            await self.getCurrentUser()
        }
       
    }
    
}

// MARK: - Public Methods

extension AppViewModel {
    
    /// Updates the global environment with the given user and sets the login state.
    /// - Parameter user: The user to set in the global environment.
    func updateUser(_ user: FSUser) {
        self.user = user
        self.authState = .authenticated
        AppStorage.userID = user.id.uuidString
    }
    
    func handleCreatePlan() {
        authDestination = .createPlan
    }
    
    func handleExistingAccount() {
        authDestination = .signin
    }
    
    func loginWithApple() {
        viewState = .loading
        
        appleSignInManager.signIn { [weak self] result in
            self?.handleAppleSignIn(result: result)
            self?.loginMethod = LoginMethod.apple.rawValue
        }
    }
    
    func handleAppleSignIn(result: Result<ASAuthorization, Error>) {
        viewState = .loading
        defer { viewState = .idle }
        switch result {
        case .success(let authorization):
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                print(appleIDCredential)
                shouldSignIn = false

                // MARK: TODO
//                Task {
//                    do {
//                        let appleUser = appleIDCredential.user
//                        let (user, _) = try await authRepository.signInWithApple(user: appleUser)
//                        updateUser(user)
//                        shouldSignIn = false
//                    } catch {
//                        FSLogger.error("Apple sign in error: \(error)")
//                    }
//                }
            }
        case .failure(let error):
            FSLogger.error("Apple sign in error: \(error)")
        }
    }
    
    func startTrial() {
        self.loginMethod = LoginMethod.trial.rawValue
        self.authState = .ontrial
    }
}

// MARK: - Private Methods

private extension AppViewModel {
    
    /// Retrieves the currently authenticated user and updates the global environment.
    func getCurrentUser() async {
        
        guard !SuperwallManager.shared.isTrialActive, !SuperwallManager.shared.isSubscrivedWithoutUserID else {
            self.authState = .ontrial
            return
        }
        
        do {
            let user = try await self.getUserUseCase.execute()
            updateUser(user)
            SuperwallManager.shared.endTrial()
            SuperwallManager.shared.switchToUser(with: user.id)
            authState = .authenticated
        } catch {
            NSLog("Login error: \(error.localizedDescription)")
            authState = .unauthenticated
        }
    }
    
    /// Initializes the global environment object with the given Supabase user.
    /// - Parameter user: The Supabase user to convert and assign.
    func initGlobalEnv(user: User) {
        let fsUser = FSUser(fromSupabaseUser: user)
        globalAppEnvObject.user = fsUser
    }
    
}

// MARK: - Google Login

extension AppViewModel: ASWebAuthenticationPresentationContextProviding {
    
    func loginWithApple() async {
        await authentiationLogin(provider: .apple)
    }
    
    func loginWithGoogle() async {
        await authentiationLogin(provider: .google)
    }
    
    func authentiationLogin(provider: AuthProvider) async {
        viewState = .loading
        errorMessage = nil
                
        do {
            let urlString = try await signinUseCase.execute(with: provider)

            guard let authURL = URL(string: urlString) else {
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
                    
                    self.handleAuthCallback(callbackURL)
                })

            authSession?.presentationContextProvider = self
            authSession?.start()
        } catch {
            errorMessage = error.localizedDescription
            print("Error during Google login: \(error.localizedDescription)")
            self.viewState = .idle
        }

    }
    
    private func handleAuthCallback(_ url: URL) {
        defer { self.viewState = .idle }
        guard let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems, let code = queryItems.first(where: { $0.name == "code" })?.value else {
            FSLogger.log("Google Auth Callback: Code not found in query parameters. URL: \(url.absoluteString)")
            return
        }
        
        Task { @MainActor in
            do {
                let session = try await signinUseCase.executeWithGoogleCallback(code: code)
                networkSession.setTokens(accessToken: session.token, refreshToken: session.refreshToken)
        
                try await createProfileUseCase.execute()
                let user = try await getUserUseCase.execute()
                SuperwallManager.shared.identifyUser(with: user.id.uuidString)
                loginMethod = LoginMethod.google.rawValue
                didSubscribedWithoutUserID = false
                shouldSignIn = false
            } catch {
                self.errorMessage = "Google Sign-In failed: \(error.localizedDescription)"
                networkSession.clearTokens()
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
}

extension AppViewModel: LoginPresenter {
    func presentLogin() {
        self.shouldSignIn = true
    }
}
