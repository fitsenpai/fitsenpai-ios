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
    
    // MARK: - UseCases
    /// Use case for fetching the current user from a data source (e.g., Supabase).
    @Inject private var getUserUseCase: GetUserUseCaseProtocol
    
    @AppState(\.loginMethod) var loginMethod: String?
    
    /// A flag indicating whether the user should be directed to the login screen.
    var isProduction: Bool {
        return EnvironmentManager.shared.value(for: .isProduction) ?? false
    }
    
    var isLoggedIn: Bool {
        return authState == .authenticated
    }
    
    private let appleSignInManager = AppleSignInManager()
    private let superwall = SuperwallManager.shared

    /// Initializes the AppViewModel.
    ///
    /// This sets up dependencies and attempts to fetch the current user to determine
    /// the authentication state and access level.
    override init() {
        super.init()
        Task { @MainActor in
            // Register as login presenter
            self.superwall.loginPresenter = self
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
    }
    
    func handleCreatePlan() {
        authDestination = .createPlan
    }
    
    func handleExistingAccount() {
        authDestination = .signin
    }
    
    func loginWithGoogle() {
        self.loginMethod = LoginMethod.google.rawValue
        guard let url = URL(string: "https://fitsenpai-web-git-docs-doument-auth-endpoints-c35204-royallabs.vercel.app/api/user/signInWithGoogle") else {
            FSLogger.error("Invalid URL for Google Sign In")
            return
        }

        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            FSLogger.error("Could not get root view controller to present SafariViewController")
            return
        }

        let safariVC = SFSafariViewController(url: url)
        rootViewController.present(safariVC, animated: true, completion: nil)
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
        self.superwall.startTrial()
        self.loginMethod = LoginMethod.trial.rawValue
        self.authState = .ontrial
    }
}



// MARK: - Private Methods

private extension AppViewModel {
    
    /// (Deprecated) Initializes the user session by checking for an active session in Supabase.
    /// This function will be removed in the future.
    /// - Throws: An error if the FSClient could not be initialized.
    func initSession() async throws {
        defer { self.viewState = .idle }
        guard let fsClient = FSClient.shared else {
            throw NSError(domain: "AppStartBlock", code: -1, userInfo: [NSLocalizedDescriptionKey: "FSClient could not be initialized."])
        }
        
        let supabaseClient = fsClient.getClient()
        
        // Check for an active session
        do {
            let session = try await supabaseClient.auth.session
            self.initGlobalEnv(user: session.user)
            print("Active session found for user: \(session.user.email ?? "unknown email")")
            
            self.authState = .authenticated
            
            // Additional startup tasks, e.g., fetching weeks to generate
            let weekGenerator = WeekGenerator(client: supabaseClient)
            if let weekToGenerate = try await weekGenerator.execute(forUser: session.user.id) {
                globalAppEnvObject.weekToGenerate = weekToGenerate
                print("Week to generate: \(weekToGenerate)")
            } else {
                print("No week data available.")
            }
        } catch {
            print("No active session found or error occurred: \(error.localizedDescription)")
            self.authState = .unauthenticated
        }
    }
    
    /// Retrieves the currently authenticated user and updates the global environment.
    func getCurrentUser() async {
        
        guard !superwall.isFirstDayTrialActive, !superwall.isSubscrivedWithoutUserID else {
            self.authState = .ontrial
            return
        }
        
        do {
            let user = try await self.getUserUseCase.execute()
            updateUser(user)
            superwall.endTrial()
            superwall.switchToUser(with: user.id)
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

// MARK: - LoginPresenter

extension AppViewModel: LoginPresenter {
    func presentLogin() {
        self.shouldSignIn = true
    }
}
