//
//  FitSenpai.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/21/24.
//

import SwiftUI
import Foundation
import SwiftData

let globalAppEnvObject = GlobalAppEnvironment()

@main
struct FitSenpai: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    /// Main view model for the App
    @StateObject private var appState = AppViewModel()
    
    /// The shared model context for SwiftData.
    private let modelContext: ModelContext

    private let superwallManager = SuperwallManager.shared
    
    init() {
        do {
            // Create a ModelContainer with the necessary entity types.
            let context = ModelContext(try ModelContainer(for: UserProfileEntity.self))
            self.modelContext = context
            self.setupDependencies()
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            Group {
                switch appState.viewState {
                case .loading, .fetching:
                    FSLoading(config: $appState.loadingConfig)
                default:
                    if appState.isLoggedIn {
                        MainTabView()
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
            .environment(\.modelContext, modelContext)
        }
        .modelContainer(for: [UserProfileEntity.self])
    }
    
    /// Registers core services and the view model itself for dependency injection.
    private func setupDependencies() {
        // Register all core services
        DependencyRegistry.registerDependencies()
        DependencyRegistry.registerDataStores(modelContext: self.modelContext)
    }
}

public func triggerHaptics() {
    let generator = UIImpactFeedbackGenerator(style: .light)
    generator.impactOccurred()
}
