//
//  EnvironmentManager.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/26/24.
//

import Foundation

enum AppKey: String {
    case name
    case isProduction
    case supabaseKey
    case supabaseProjectURL
    
}

final class EnvironmentManager {
    static let shared = EnvironmentManager()
    private var config: [String: Any] = [:]

    private init() {
        loadConfig()
    }

    /// Loads the appropriate plist based on the current scheme
    private func loadConfig() {
        #if DEV
        let fileName = "config-dev"
        #else
        let fileName = "config-prod"
        #endif
        
        guard let path = Bundle.main.path(forResource: fileName, ofType: "plist"),
              let data = FileManager.default.contents(atPath: path),
              let config = try? PropertyListSerialization.propertyList(from: data, format: nil) as? [String: Any] else {
            fatalError("Unable to load \(fileName).plist")
        }
        
        self.config = config
    }

    /// Fetches a value for the given key
    /// - Parameter key: The key to retrieve
    /// - Returns: The value for the key, or `nil` if not found
    func value<T>(for key: AppKey) -> T? {
        return config[key.rawValue] as? T
    }
}
