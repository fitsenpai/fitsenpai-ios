//
//  AppState.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/27/24.
//

import Foundation
import Supabase
import AuthenticationServices

/// A view model responsible for managing the global app state,
/// including user authentication and initialization logic.
@MainActor
class AppViewModel: NSObject, ObservableObject {
    // MARK: - Properties
    
    /// The authenticated user object, if available.
    @Published var user: FSUser?
    
    /// The authenticated user profile object, if available.
    @Published var userProfile: FSProfile?
    
    /// Indicates whether the user is currently logged in.
    @Published var isLoggedIn: Bool = false
    
    /// Represents the current view state of the app, used for loading indicators.
    @Published var viewState: ViewState = .loading
    
    /// Determines the current navigation destination during onboarding.
    @Published var authDestination: AuthNavDestination? = nil
    
    /// Configuration for displaying loading indicators throughout the app.
    @Published var loadingConfig: FSLoadingConfig = .defaultConfig
    
    /// A flag indicating whether the user should be directed to the login screen.
    @Published var shouldLogin: Bool = false
    
    /// A flag indicating whether the user should be directed to the sign in screen.
    @Published var shouldSignIn: Bool = false
    
    /// Use case for fetching the current user from a data source (e.g., Supabase).
    @Inject private var getUserUseCase: GetUserUseCaseProtocol
    
    /// Auth repository for handling authentication logic
    @Inject private var authRepository: AuthRepositoryProtocol
    
    /// A flag indicating whether the user should be directed to the login screen.
    var isProduction: Bool {
        return EnvironmentManager.shared.value(for: .isProduction) ?? false
    }
    
    private let appleSignInManager = AppleSignInManager()
    
    /// Initializes the AppViewModel.
    ///
    /// This sets up dependencies and attempts to fetch the current user to determine
    /// the authentication state and access level.
    override init() {
        super.init()
        self.setupDependencies()
        Task { @MainActor in
            await self.getCurrentUser()
        }
        // Register as login presenter
        SuperwallViewModel.shared.loginPresenter = self
    }
    
}


// MARK: - Public Methods

extension AppViewModel {
    
    /// Updates the global environment with the given user and sets the login state.
    /// - Parameter user: The user to set in the global environment.
    func updateUser(_ user: FSUser) {
        self.user = user
        self.isLoggedIn = true
    }
    
    func createLimitedWorkoutPlan() async {
        SuperwallViewModel.shared.startTrial()
        
        self.viewState = .loading
        self.loadingConfig = .init(title: "Getting everything\nready for you", subtitle: "Customizing your workout plan...")
        try? await Task.sleep(for: .seconds(3))
        self.viewState = .idle
        self.isLoggedIn = true
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
        }
    }
    
    // ADD: Apple sign in handler
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
}



// MARK: - Private Methods

private extension AppViewModel {
    /// Registers core services and the view model itself for dependency injection.
    func setupDependencies() {
        // Register all core services
        CoreServices.registerAll()
        // Register self as singleton
        DependencyInjector.register(self)
    }
    
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
            
            self.isLoggedIn = true
            
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
            self.isLoggedIn = true
        }
    }
    
    /// Retrieves the currently authenticated user and updates the global environment.
    func getCurrentUser() async {
        let superwall = SuperwallViewModel.shared
        
        defer { self.viewState = .idle }
        guard !superwall.isFirstDayTrialActive, !superwall.isSubscrivedWithoutUserID else {
            self.isLoggedIn = true
            return
        }
        
        do {
            let user = try await self.getUserUseCase.execute()
            updateUser(user)
            superwall.endTrial()
            superwall.switchToUser(with: user.id)
        } catch {
            // TODO: Replace with proper error logging mechanism
            NSLog("Login error: \(error.localizedDescription)")
        }
    }
    
    /// Initializes the global environment object with the given Supabase user.
    /// - Parameter user: The Supabase user to convert and assign.
    private func initGlobalEnv(user: User) {
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
