//
//  AppState.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/27/24.
//

import Foundation
import Supabase

@MainActor
class AppViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var viewState: ViewState = .loading
    
    init() {
        self.setupDependencies()
        Task { @MainActor in
           try await self.initSession()
        }
    }
    
    func initSession() async throws {
        defer { viewState = .idle }
        guard let fsClient = FSClient.shared else {
            throw NSError(domain: "AppStartBlock", code: -1, userInfo: [NSLocalizedDescriptionKey: "FSClient could not be initialized."])
        }
        

        let supabaseClient = fsClient.getClient()
        
        // Check for an active session
        do {
            let session = try await supabaseClient.auth.session
            initGlobalEnv(user: session.user)
            print("Active session found for user: \(session.user.email ?? "unknown email")")
            
            isLoggedIn = true
            
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
            
            isLoggedIn = false
        }
    }
    
    private func initGlobalEnv(user: User) {
        let fsUser = FSUser(fromSupabaseUser: user)
        globalAppEnvObject.user = fsUser
    }
    
    private func setupDependencies() {
        // Register core services
        DependencyInjector.register(NetworkService() as NetworkServiceProtocol)
        DependencyInjector.register(AuthRepository() as AuthRepositoryProtocol)
    }
    
}

