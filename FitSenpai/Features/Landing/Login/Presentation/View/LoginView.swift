//
//  LoginView.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/20/24.
//

import SwiftUI

struct LoginView: View {
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var appViewModel: AppViewModel
    @StateObject private var viewModel = LoginViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 36) {
            Spacer()
            
            FSText(text: "Sign in", fontStyle: .heading30, color: .fsTitle)

            VStack(spacing: 32) {
                RoundedBorderTextField(text: $viewModel.email, label: "Email", cornerRadius: 12)
                VStack(alignment: .leading, spacing: 10) {
                    RoundedBorderTextField(text: $viewModel.password, label: "Password", isSecure: true, showAccessory: true, cornerRadius: 12)
                    Button {
                        viewModel.showForgotPassword = true
                    } label: {
                        FSText(text: "Forgot password?", fontStyle: .body14, letterSpace: 0, color: Color.fsMutedForeground, isUnderlined: true)
                    }
                }
            }

            FSButton(title: viewModel.viewState == .loading ? "Logging in..." : "Login", fontStyle: .bodyBold16, cornerRadius: 32) {
                Task {
                    if await viewModel.login() {
                        appViewModel.isLoggedIn = true
                    }
                }
            }
            .disabled(viewModel.viewState == .loading)

            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }
            
            ZStack {
                Divider()
                FSText(text: "or login with", fontStyle: .body14, letterSpace: 0, color: Color.fsMutedForeground, isUnderlined: false)
                    .padding(.horizontal, 24)
                    .background(Color.white)
            }
            
            HStack {
                FSButton(icon: "apple-logo", title: "Apple", fontStyle: .bodyBold16, foregroundColor: .white, cornerRadius: 100, background: .black) {
                    Task {
                        if await viewModel.loginWithApple() {
                            appViewModel.isLoggedIn = true
                        }
                    }
                }
                
                FSButton(icon: "google-logo", title: "Google", fontStyle: .bodyBold16, cornerRadius: 100, background: .white, borderColor: .fsPurple) {
                    Task {
                        if await viewModel.loginWithGoogle() {
                            appViewModel.isLoggedIn = true
                        }
                    }
                }
            }

            Spacer()

            HStack(spacing: 2) {
                Spacer()
                FSText(text: "Don't have an account?", fontStyle: .body14, color: .fsTitle)
                
                FSText(text: "Sign up here.", fontStyle: .heading14, color: .fsAccentForeground)
                    .onTapGesture {
                        dismiss()
                    }
                Spacer()
            }
            .padding(.bottom)
        }
        .padding(.horizontal, 24)
        .padding(.top, 63)
        .navigationBarBackButtonHidden()
        .loadingOverlay(state: $viewModel.viewState)
        .navigationDestination(isPresented: $viewModel.showForgotPassword) {
            ForgotPasswordView()
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(AppViewModel())
    }
}
