//
//  FitSenpai.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/21/24.
//

import SwiftUI
import Foundation
import Supabase

let globalAppEnvObject = GlobalAppEnvironment()

@main
struct FitSenpai: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var appState = AppViewModel()
    private let superwallManager = SuperwallViewModel.shared

    var body: some Scene {
        WindowGroup {
            Group {
                switch appState.viewState {
                case .loading, .fetching:
                    FSLoading(config: $appState.loadingConfig)
                default:
                    if appState.isLoggedIn {
                        FSTabView()
                            .environmentObject(appState)
                            .environmentObject(superwallManager)
                    } else {
                        OnboardingView()
                            .environmentObject(appState)
                            .environmentObject(superwallManager)
                    }
                }
            }
            .preferredColorScheme(.light)
        }
        
    }
}

public func triggerHaptics() {
    let generator = UIImpactFeedbackGenerator(style: .light)
    generator.impactOccurred()
}
