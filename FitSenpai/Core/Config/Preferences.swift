//
//  Preferences.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/8/25.
//

import Foundation
import Combine

final class Preferences {
    
    static let standard = Preferences(userDefaults: .standard)
    private(set) var userDefaults: UserDefaults
    
    /// Sends through the changed key path whenever a change occurs.
    var preferencesChangedSubject = PassthroughSubject<AnyKeyPath, Never>()
    
    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
    
    @UserDefault("userID")
    var userID: String? = nil
    
    @UserDefault("userEmail")
    var userEmail: String? = nil
    
    @UserDefault("accessToken")
    var accessToken: String? = nil
    
    @UserDefault("refreshToken")
    var refreshToken: String? = nil
    
    @UserDefault("isLimited")
    var isLimited: Bool = false
}
