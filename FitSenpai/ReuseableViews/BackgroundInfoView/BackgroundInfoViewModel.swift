//
//  BackgroundInfoViewModel.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 12/17/24.
//

import Foundation
import SwiftUI

// MARK: - ViewModel
struct BackgroundInfoViewModel {
    let iconName: String       // Image name for the icon
    let iconTint: Color        // Tint color for the icon
    let title: String          // Title text
    let mainLabel: String      // Main content text
    let buttonLabel: String    // Button label text
    let buttonAction: () -> Void  // Action for the button
    
    // Default initializer for testing or previews
    static let defaultConfig = BackgroundInfoViewModel(
        iconName: "ic_lock_simple",
        iconTint: .fsAccentForeground,
        title: "More weeks to unlock\nwith your next billing cycle",
        mainLabel: "Great progress so far! Your new plans will be available on Month Day, Year. Keep up the momentum!",
        buttonLabel: "Back to active week",
        buttonAction: { print("Button tapped") }
    )
}
