//
//  AppStart.swift
//  FitSenpai
//
//  Created by Kevin M on 12/26/24.
//

import Foundation
import Supabase

protocol AppStartUseCase {
    func execute() async throws
}

struct AppStartBlock {
    static func execute(appState: AppState) async throws {
        guard let fsClient = FSClient.shared else {
            throw NSError(domain: "AppStartBlock", code: -1, userInfo: [NSLocalizedDescriptionKey: "FSClient could not be initialized."])
        }

        let supabaseClient = fsClient.getClient()
        
        // Check for an active session
        do {
            let session = try await supabaseClient.auth.session
            initGlobalEnv(user: session.user)
            print("Active session found for user: \(session.user.email ?? "unknown email")")
            DispatchQueue.main.async {
                appState.isLoggedIn = true
            }
            
            // Additional startup tasks, e.g., fetching weeks to generate
            let weekGenerator = WeekGenerator(client: supabaseClient)
            if let weekToGenerate = try await weekGenerator.fetchWeekToGenerate(forUser: session.user.id) {
                globalAppEnvObject.weekToGenerate = weekToGenerate
                print("Week to generate: \(weekToGenerate)")
            } else {
                print("No week data available.")
            }
        } catch {
            print("No active session found or error occurred: \(error.localizedDescription)")
            appState.isLoggedIn = false
        }
    }
    
    private static func initGlobalEnv(user: User) {
        let fsUser = FSUser(fromSupabaseUser: user)
        globalAppEnvObject.user = fsUser
    }
}
