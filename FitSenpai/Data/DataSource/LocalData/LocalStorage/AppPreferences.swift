//
//  UserPreferences.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/8/25.
//

import Foundation
import Combine

/// A singleton class for managing and storing user preferences using `UserDefaults`.
/// This class provides an interface to save and retrieve user-specific settings
/// such as user ID, email, access tokens, and trial start date.
final class AppPreferences {
    
    /// A shared instance for accessing user preferences.
    ///
    /// This singleton is used to provide a centralized instance for accessing
    /// user preferences throughout the app.
    static let standard = AppPreferences(userDefaults: .standard)
    
    /// A `UserDefaults` instance used for reading and writing user preferences.
    private(set) var userDefaults: UserDefaults
    
    /// A subject used to publish changes to user preferences. This allows other parts
    /// of the app to listen for changes to any of the preferences stored.
    var preferencesChangedSubject = PassthroughSubject<AnyKeyPath, Never>()
    
    /// Initializes the `UserPreferences` instance with a custom `UserDefaults` instance.
    /// 
    /// - Parameter userDefaults: The `UserDefaults` instance to use for storing preferences.
    ///   Defaults to `.standard` if not provided.
    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
    
    // MARK: - User Preferences Properties
    
    /// The user’s unique ID.
    ///
    /// This value is stored in `UserDefaults` and represents the current user's ID.
    @UserDefault("userID")
    var userID: String? = nil
    
    /// The user’s email address.
    ///
    /// This value is stored in `UserDefaults` and is used for identifying the user.
    @UserDefault("userEmail")
    var userEmail: String? = nil
    
    /// The current access token for the user.
    ///
    /// This value is used for authenticating requests to the server.
    @UserDefault("accessToken")
    var accessToken: String? = nil
    
    /// The current refresh token for the user.
    ///
    /// This value is used for refreshing the access token when it expires.
    @UserDefault("refreshToken")
    var refreshToken: String? = nil
    
    /// The trial start date for the user.
    ///
    /// This value is used to track the start date of the user's trial period.
    @UserDefault("trialStartDate")
    var trialStartDate: Date? = nil
    
    /// A flag indicating whether the user subscribed without providing a user ID.
    ///
    /// This value is used to track whether the user has subscribed without an ID.
    @UserDefault("didSubscribedWithoutUserID")
    var didSubscribedWithoutUserID: Bool = false
    
    /// The users login method.
    ///
    /// This value is used to track whether the user login via email, apple or google.
    @UserDefault("loginMethod")
    var loginMethod: String? = nil
}
