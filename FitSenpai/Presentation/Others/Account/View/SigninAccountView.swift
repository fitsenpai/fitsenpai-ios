//
//  CreateAccountView.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/16/25.
//

import SwiftUI

struct SigninAccountView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var appViewModel: AppViewModel
    @StateObject private var viewModel = SignInAccountViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 36) {
            Spacer()
                .frame(height: 40)
            
            VStack(alignment: .leading, spacing: 8) {
                FSTextView("Create your account", typography: .h2)
                FSTextView("Use Apple or Google to create your account quickly and securely.", typography: .body)
            }
            .padding(.horizontal, 24)
            
            Spacer()
            
            VStack(spacing: 16) {
                FSButton(icon: "apple-logo",
                        title: "Sign in with Apple", 
                        fontStyle: .bodyBold16,
                        foregroundColor: .white,
                        cornerRadius: 100,
                        background: .black) {
                    appViewModel.loginWithApple()
                }
                        .disabled(true)
                
                FSButton(icon: "google-logo",
                        title: "Sign in with Google",
                        fontStyle: .bodyBold16,
                        cornerRadius: 100,
                        background: .white,
                        borderColor: .fsPurple) {
                    Task {
                        await viewModel.loginWithGoogle()
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .loadingOverlay(state: $viewModel.viewState)
        .withToastOverlay()
        .onReceive(viewModel.$didSignIn) { signedIn in
            if signedIn {
                dismiss()
            }
        }
    }
}

#Preview {
    SigninAccountView()
        .environmentObject(AppViewModel())
}
