//
//  FSClient.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/26/24.
//

import Foundation
import Supabase

class FSClient {
    // Shared instance for Singleton
    static let shared = FSClient()

    // Private property for SupabaseClient
    private let client: SupabaseClient

    // Private initializer to enforce Singleton
    private init?() {
        guard
            let url: String = EnvironmentManager.shared.value(for: .supabaseProjectURL),
            let key: String = EnvironmentManager.shared.value(for: .supabaseKey),
            let supabaseURL = URL(string: url)
        else {
            print("Failed to initialize FSClient. Check your environment variables.")
            return nil
        }

        // Initialize the SupabaseClient
        self.client = SupabaseClient(supabaseURL: supabaseURL, supabaseKey: key)
    }

    // Method to access the SupabaseClient
    func getClient() -> SupabaseClient {
        return client
    }
}
