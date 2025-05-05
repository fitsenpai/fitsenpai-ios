//
//  AppView.swift
//  FitSenpai
//
//  Created by Mark Daquis on 5/5/25.
//

import SwiftUI

struct AppView: View {
    @EnvironmentObject var appState: AppViewModel

    var body: some View {
        Group {
            switch appState.authState {
            case .checkingAuth:
                FSLoading(config: .constant(.defaultConfig))
            case .authenticated, .ontrial:
                MainTabView()
            case .unauthenticated:
                LandingView()
            }
        }
    }
}
