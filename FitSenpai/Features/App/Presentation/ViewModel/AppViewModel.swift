//
//  AppState.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/27/24.
//

import Foundation
import Supabase

/// A view model responsible for managing the global app state,
/// including user authentication and initialization logic.
@MainActor
class AppViewModel: ObservableObject {
    // MARK: - Properties
    
    /// Indicates whether the user is currently logged in.
    @Published var isLoggedIn: Bool = false
    
    /// Represents the current view state of the app, used for loading indicators.
    @Published var viewState: ViewState = .loading
    
    /// Use case for retrieving the current user data.
    @Inject private var getUserUseCase: GetUserUseCaseProtocol
    
    // MARK: - Initializer
    
    /// Initializes the app view model and begins user session validation.
    init() {
        self.setupDependencies()
        Task { @MainActor in
            await self.getCurrentUser()
        }
    }
    
    // MARK: - Public Methods
    
    /// Updates the global environment with the given user and sets the login state.
    /// - Parameter user: The user to set in the global environment.
    func updateUser(_ user: FSUser) {
        globalAppEnvObject.user = user
        self.isLoggedIn = true
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
    
    // MARK: - Private Methods
    
    /// Retrieves the currently authenticated user and updates the global environment.
    private func getCurrentUser() async {
        defer { self.viewState = .idle }
        
        do {
            let user = try await self.getUserUseCase.execute()
            updateUser(user)
        } catch {
            // TODO: Replace with proper error logging mechanism
            NSLog("Login error: \(error.localizedDescription)")
            self.isLoggedIn = false
        }
    }
    
    /// Initializes the global environment object with the given Supabase user.
    /// - Parameter user: The Supabase user to convert and assign.
    private func initGlobalEnv(user: User) {
        let fsUser = FSUser(fromSupabaseUser: user)
        globalAppEnvObject.user = fsUser
    }
    
    /// Registers core services and the view model itself for dependency injection.
    private func setupDependencies() {
        // Register all core services
        CoreServices.registerAll()
        // Register self as singleton
        DependencyInjector.register(self)
    }
}
