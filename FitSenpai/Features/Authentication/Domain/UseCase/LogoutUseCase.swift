//
//  LogoutUseCase.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/27/24.
//

import Foundation
import Supabase

struct LogoutUseCase {
    func logout() async throws {
        guard let fsClient = FSClient.shared else {
            throw LogoutError.clientNotInitialized
        }
        
        let supabaseClient = fsClient.getClient()
        
        do {
            try await supabaseClient.auth.signOut()
            print("Successfully logged out.")
        } catch {
            print("Failed to log out: \(error.localizedDescription)")
            throw error
        }
    }
    
    enum LogoutError: Error {
        case clientNotInitialized
    }
}
