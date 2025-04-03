//
//  AuthManager.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/2/25.
//


import Foundation

/// Manages authentication state and tokens
final class AuthManager {
    /// Shared instance for authentication management
    static let shared = AuthManager()
    
    /// Current access token for API requests
    private(set) var accessToken: String?
    
    /// Refresh token for obtaining new access tokens
    private(set) var refreshToken: String?
    
    /// Returns true if user is authenticated (has valid access token)
    var isAuthenticated: Bool {
        accessToken != nil
    }
    
    /// Private initializer to ensure singleton pattern
    private init() {
        // Load tokens from secure storage if available
        loadTokens()
    }
    
    /// Sets new authentication tokens
    /// - Parameters:
    ///   - accessToken: The new access token
    ///   - refreshToken: The new refresh token
    func setTokens(accessToken: String, refreshToken: String) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        // Save tokens to secure storage
        saveTokens()
    }
    
    /// Clears all authentication tokens
    func clearTokens() {
        self.accessToken = nil
        self.refreshToken = nil
        // Remove tokens from secure storage
        removeTokens()
    }
    
    /// Attempts to refresh the access token using the refresh token
    /// - Returns: A new access token
    /// - Throws: NetworkError if refresh fails
    func refreshAccessToken() async throws -> String {
        guard refreshToken != nil else {
            throw NetworkError.unauthorized
        }
        
        // TODO: Implement token refresh logic
        // Make API call to refresh token
        throw NetworkError.unauthorized
    }
    
    // MARK: - Private Methods
    
    private func saveTokens() {
        // Save to UserDefaults for now, should use Keychain in production
        let defaults = UserDefaults.standard
        defaults.set(accessToken, forKey: "accessToken")
        defaults.set(refreshToken, forKey: "refreshToken")
    }
    
    private func loadTokens() {
        // Load from UserDefaults for now, should use Keychain in production
        let defaults = UserDefaults.standard
        accessToken = defaults.string(forKey: "accessToken")
        refreshToken = defaults.string(forKey: "refreshToken")
    }
    
    private func removeTokens() {
        // Remove from UserDefaults for now, should use Keychain in production
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "accessToken")
        defaults.removeObject(forKey: "refreshToken")
    }
}

// MARK: - Custom String Convertible

extension AuthManager: CustomStringConvertible {
    var description: String {
        "AuthManager(isAuthenticated: \(isAuthenticated))"
    }
}

// MARK: - Debug Description

#if DEBUG
extension AuthManager: CustomDebugStringConvertible {
    var debugDescription: String {
        """
        AuthManager(
            isAuthenticated: \(isAuthenticated),
            accessToken: \(accessToken?.prefix(10) ?? "nil")...,
            refreshToken: \(refreshToken?.prefix(10) ?? "nil")...
        )
        """
    }
}
#endif

