//
//  GeneralInfoViewModel.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/8/25.
//

import Foundation
import SwiftUI

// MARK: - ViewModel
struct GeneralInfoViewModel {
    let iconName: String
    let iconTint: Color
    let iconBackground: Color
    let title: String
    let mainLabel: String
    let buttonLabel: String
    var containerHeight: CGFloat = 320
    var showButton : Bool = true
    var showBorder : Bool = true
    var isLoading : Bool = false
    let buttonAction: () -> Void
    
    // Default initializer for testing or previews
    static let defaultConfig = GeneralInfoViewModel(
        iconName: "ic_calendar_check",
        iconTint: .fsAccentForeground,
        iconBackground: .fsAccent,
        title: "Week 5 is now unlocked!",
        mainLabel: "Tap below to generate your new workout and\nmeal plans. This may take a few minutes.",
        buttonLabel: "Generate plans",
        containerHeight: 320,
        buttonAction: { print("Button tapped") }
    )
    
    static let loadingConfig = GeneralInfoViewModel(iconName: "", iconTint: .clear, iconBackground: .clear, title: "", mainLabel: "Checking session...", buttonLabel: "", containerHeight: .infinity, showButton: false, showBorder: false, isLoading: true, buttonAction: {
    })
}
