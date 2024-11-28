//
//  AuthUseCase.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/27/24.
//

import Foundation
import Supabase

struct AuthUseCase {
    static func checkActiveSession() async -> Bool {
        guard let fsClient = FSClient.shared else {
            print("FSClient could not be initialized.")
            return false
        }

        let supabaseClient = fsClient.getClient()

        // Check for an active session directly
        do {
            let session = try await supabaseClient.auth.session
            initGlobalEnv(user: session.user)
            print("Active session found for user: \(session.user.email ?? "unknown email")")
            return true
        } catch {
            print("No active session found or error occurred: \(error.localizedDescription)")
            return false
        }
    }

    static func clearSession() async {
        guard let fsClient = FSClient.shared else {
            print("FSClient could not be initialized.")
            return
        }

        let supabaseClient = fsClient.getClient()

        do {
            try await supabaseClient.auth.signOut()
            print("Session cleared successfully.")
        } catch {
            print("Failed to clear session: \(error.localizedDescription)")
        }
    }
    
    private static func initGlobalEnv(user: User){
        let fsUser = FSUser.init(fromSupabaseUser: user)
        globalAppEnvObject.user = fsUser
    }
}
