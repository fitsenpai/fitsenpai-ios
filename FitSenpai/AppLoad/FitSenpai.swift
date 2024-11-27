//
//  FitSenpai.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/21/24.
//

import SwiftUI

@main
struct FitSenpai: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var appState = AppState()
    @State private var isLoading = true

    var body: some Scene {
        WindowGroup {
            Group {
                if isLoading {
                    ProgressView("Checking session...")
                } else if appState.isLoggedIn {
                    FSTabView()
                        .environmentObject(appState)
                } else {
                    AuthLandingView()
                        .environmentObject(appState)
                }
            }
            .task {
                isLoading = true
                appState.isLoggedIn = await AuthUseCase.checkActiveSession()
                isLoading = false
            }
        }
    }
}
