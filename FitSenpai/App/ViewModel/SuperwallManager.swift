//
//  SuperwallManager.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/16/25.
//

/// SuperwallManager
///
/// A singleton class to manage Superwall SDK integration within the FitSenpai app.
/// Handles configuration, user identification, paywall presentation, subscription state monitoring,
/// and restoring purchases.
///
/// ### Usage
/// - Call `SuperwallManager.shared.configure()` once during app launch.
/// - Use `presentPaywall(for:)` to trigger a paywall.
/// - Use `identifyUser(with:)` after user login/signup to associate subscriptions.
/// - Use `resetUser()` on logout to clear the current user context.
/// - Use `switchToUser(with:)` if switching users (automatically resets and identifies).
/// - Monitor `SuperwallManager.shared.status` for subscription status updates.
/// - Use `restore()` to attempt restoring purchases (e.g., from a Restore button).
///
/// ### Notes
/// - This manager uses Combine to publish subscription status updates.
/// - Be sure to call `identifyUser` after anonymous subscriptions to link them to a real account.

import SwiftUI
import Foundation
import SuperwallKit
import Combine
import UIKit
import AdSupport
import OSLog
import CoreKit

private let logger = Logger(
    subsystem: Bundle.main.bundleIdentifier ?? "SuperwallManager",
    category: String(describing: SuperwallManager.self)
)

enum FSAccessLevel {
    case freeTrial     // within 1-day free usage
    case subscribed    // monthly, annual, lifetime
    case expired       // expired or cancelled sub with history
    case locked        // no access at all
}

enum FSPaywallIdentifier: String {
    case proContent = "campaign_trigger"
}

enum FSSubscriptionStatus: Equatable {
    case active
    case inactive
    case unknown
    
    init(from status: SubscriptionStatus) {
        switch status {
        case .active: self = .active
        case .inactive: self = .inactive
        case .unknown: self = .unknown
        }
    }
}

@MainActor
protocol LoginPresenter: AnyObject {
    func presentLogin()
}

@MainActor
final class SuperwallManager: ObservableObject, SuperwallDelegate {
    
    // MARK: - Singleton
    
    static let shared = SuperwallManager()
    
    // MARK: - Published Properties
    
    @Published private(set) var status: FSSubscriptionStatus = .unknown
    @Published private(set) var accessLevel: FSAccessLevel = .locked
    @Published var userId: String?
    
    // MARK: - App State Properties
    
    @AppState(\.trialStartDate) private var trialStartDate: Date?
    @AppState(\.didSubscribedWithoutUserID) private var didSubscribedWithoutUserID: Bool
    
    @Inject private var workoutDataStore: WorkoutDataStore
    @Inject private var mealsDataStore: MealsDataStore
    @Inject private var groceryDataDataStore: GroceriesDataStore
    
    // MARK: - Private Properties
    
    private var cancellables = Set<AnyCancellable>()
    private let apiKey = "pk_46e1d4de08443cebfe5adf0aebbe795dbf96125a991a6a6d"
    weak var loginPresenter: LoginPresenter?
    
    private var deviceId: UUID? {
        if let uuid = DeviceUUID.getUUID() {
            return uuid
        }
        
        let idfa = ASIdentifierManager.shared().advertisingIdentifier
        if idfa.uuidString != "00000000-0000-0000-0000-000000000000" {
            logger.debug("📱 Using IDFA: \(idfa.uuidString, privacy: .public)")
            return idfa
        }
        
        if let idfv = UIDevice.current.identifierForVendor {
            logger.debug("📱 Using IDFV: \(idfv.uuidString, privacy: .public)")
            return idfv
        }
        
        return nil
    }
    
    // MARK: - Computed Properties
    
    /// Returns true if user has an active subscription
    var isSubscribed: Bool {
        status == .active
    }
    
    /// Returns true if user can safely logout
    var canLogout: Bool {
        !isFirstDayTrialActive
    }
    
    /// Returns true if user is within their first 24-hour trial period
    var isFirstDayTrialActive: Bool {
        guard let trialStartDate else { return false }
        return Date().timeIntervalSince(trialStartDate) < 86400 // 24 hours
    }
    
    /// Returns true if user subscribed without being logged in
    var isSubscrivedWithoutUserID: Bool {
        return didSubscribedWithoutUserID
    }
    
    // MARK: - Initialization
    
    private init() {
        configure()
        observeSubscriptionStatus()
    }
    
    // MARK: - Configuration
    
    /// Configures Superwall SDK with API key and initial setup
    func configure() {
        Superwall.configure(apiKey: apiKey)
        Superwall.shared.delegate = self
    }
    
    // MARK: - Trial Management
    
    /// Starts the trial period by setting the start date
    func startTrial() {
        trialStartDate = Date()
    }
    
    /// Ends the trial period by removing the start date
    func endTrial() {
        trialStartDate = nil
    }
    
    // MARK: - Paywall Presentation
    
    /// Presents a paywall for the specified identifier
    /// - Parameter identifier: The paywall identifier to present
    func presentPaywall(for identifier: FSPaywallIdentifier) {
        Superwall.shared.register(placement: identifier.rawValue) { [weak self] in
            guard let self else { return }
            
            let status = Superwall.shared.subscriptionStatus
            if case .active = status {
                self.handleSubscriptionUpdate()
                
                // Show login screen if user subscribed without being logged in
                if self.userId == nil {
                    self.loginPresenter?.presentLogin()
                }
                
                workoutDataStore.deleteAll()
                mealsDataStore.deleteAll()
                groceryDataDataStore.deleteAll()
            }
        }
    }
    
    // MARK: - Subscription Management
    
    /// Updates subscription state when a purchase is successful
    private func handleSubscriptionUpdate() {
        self.didSubscribedWithoutUserID = true
        self.endTrial()
    }
    
    /// Observes changes in subscription status
    private func observeSubscriptionStatus() {
        Superwall.shared.$subscriptionStatus
            .receive(on: DispatchQueue.main)
            .map(FSSubscriptionStatus.init)
            .sink { [weak self] status in
                guard let self else { return }
                logger.debug("Subscription status changed to: \(String(describing: status))")
                
                self.status = status
                if case .active = status {
                    self.endTrial()
                    logger.debug("Subscription is active, ending trial period")
                }
            }
            .store(in: &cancellables)
    }
    
    /// Attempts to restore previous purchases
    func restore() async {
        logger.debug("Starting purchase restoration...")
        
        if let userId {
            logger.debug("Restoring purchases for user: \(userId)")
            Superwall.shared.identify(userId: userId)
        } else if let deviceId = deviceId {
            logger.debug("No user ID found, using device ID: \(deviceId)")
            Superwall.shared.identify(userId: deviceId.uuidString)
        }
        
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        let preRestoreStatus = Superwall.shared.subscriptionStatus
        logger.debug("Pre-restore subscription status: \(preRestoreStatus)")
        
        let result = await Superwall.shared.restorePurchases()
        
        switch result {
        case .restored:
            logger.debug("🔄 Restore successful")
            let postRestoreStatus = Superwall.shared.subscriptionStatus
            logger.debug("Post-restore subscription status: \(postRestoreStatus)")
            
            if case .active = postRestoreStatus {
                await MainActor.run {
                    self.endTrial()
                    self.status = .active
                    self.didSubscribedWithoutUserID = true
                }
            }
            
        case .failed(let error):
            logger.error("❌ Restore failed: \(String(describing: error))")
            let currentStatus = Superwall.shared.subscriptionStatus
            logger.debug("Current subscription status after failed restore: \(currentStatus)")
        }
    }
    
    // MARK: - User Management
    
    /// Identifies a user with Superwall
    /// - Parameter userID: The unique identifier for the user
    func identifyUser(with userID: String) {
        Superwall.shared.identify(userId: userID)
        logger.debug("🔐 Identified user with ID: \(userID)")
    }
    
    /// Resets the current user session
    func resetUser() {
        Superwall.shared.reset()
        userId = nil
        logger.debug("🔓 User reset")
    }
    
    /// Switches to a different user
    /// - Parameter id: The UUID of the user to switch to
    func switchToUser(with id: UUID?) {
        userId = id?.uuidString
        Superwall.shared.reset()
        if let id {
            Superwall.shared.identify(userId: id.uuidString)
            logger.debug("🔄 Switched to user with ID: \(id)")
        }
    }
    
    func restoreSubscription(with userID: UUID?) async {
        self.userId = userID?.uuidString
        await self.restore()
    }
}
