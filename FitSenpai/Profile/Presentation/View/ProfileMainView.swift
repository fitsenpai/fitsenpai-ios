//
//  ProfileMainView.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/22/24.
//

import SwiftUI
struct ProfileMainView: View {
    @EnvironmentObject var appState: AppState
    let logoutUseCase = LogoutUseCase()
    
    var body: some View {
        FSButton(title: "Logout") {
            Task {
                do {
                    try await logoutUseCase.logout()
                    // Clear session in AuthUseCase as part of logout
                    await AuthUseCase.clearSession()
                    
                    // Set isLoggedIn to false to navigate back to LoginView
                    DispatchQueue.main.async {
                        appState.isLoggedIn = false
                    }
                } catch {
                    print("Error during logout: \(error.localizedDescription)")
                }
            }
        }
    }
}

#Preview {
    ProfileMainView()
}
