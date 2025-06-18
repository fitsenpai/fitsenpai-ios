//
//  GeneralInfoViewModel.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/8/25.
//

import Foundation
import SwiftUI

// MARK: - ViewModel
struct FSInfoViewModel {
    let iconName: ImageResource?
    let title: String
    let mainLabel: String
    let buttonLabel: String
    var containerHeight: CGFloat = 320
    var showButton : Bool = true
    var showBorder : Bool = true
    var isLoading : Bool = false
    let buttonAction: () -> Void
    
    // Default initializer for testing or previews
    static let defaultConfig = FSInfoViewModel(
        iconName: .icCalendarCheck,
        title: "Week 5 is now unlocked!",
        mainLabel: "Tap below to generate your new workout and\nmeal plans. This may take a few minutes.",
        buttonLabel: "Generate plans",
        containerHeight: 320,
        buttonAction: { print("Button tapped") }
    )
    
    static let checkSession = FSInfoViewModel(iconName: nil, title: "", mainLabel: "Checking session...", buttonLabel: "", containerHeight: .infinity, showButton: false, showBorder: false, isLoading: true, buttonAction: {
    })
}
