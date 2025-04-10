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

    var body: some Scene {
        WindowGroup {
            Group {
                if appState.viewState == .loading {
                    GeneralInfoView(viewModel: appState.loadingVM)
                } else if appState.isLoggedIn {
                    FSTabView()
                        .environmentObject(appState)
                } else {
                    OnboardingView()
                        .environmentObject(appState)
                }
            }
            .preferredColorScheme(.light)
        }
    }
}
