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
        iconName: "ic_calendar_check",
        iconTint: .fsAccentForeground,
        title: "Week 5 is now unlocked!",
        mainLabel: "Tap below to generate your new workout and\nmeal plans. This may take a few minutes.",
        buttonLabel: "Generate plans",
        buttonAction: { print("Button tapped") }
    )
}
