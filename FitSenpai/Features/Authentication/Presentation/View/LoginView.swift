//
//  LoginView.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/20/24.
//

import SwiftUI

struct LoginView: View {
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var appState: AppViewModel
    @StateObject private var viewModel: LoginViewModel

    init(viewModel: LoginViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 36) {
            Spacer()
            
            FSText(text: "Sign in", fontStyle: .heading30, color: .fsTitle)

            VStack(spacing: 32) {
                RoundedBorderTextField(text: $viewModel.email, placeholder: "Email", cornerRadius: 12)
                VStack(alignment: .leading, spacing: 10) {
                    RoundedBorderTextField(text: $viewModel.password, placeholder: "Password", isSecure: true, showAccessory: true, cornerRadius: 12)
                    FSText(text: "Forgot password?", fontStyle: .body14, letterSpace: 0, color: Color.fsSubtitleColor, isUnderlined: true)
                }
            }

            FSButton(title: viewModel.isLoading ? "Logging in..." : "Login", fontStyle: .bodyBold16, cornerRadius: 32) {
                Task { 
                    if await viewModel.login() {
                        appState.isLoggedIn = true
                    }
                }
            }
            .disabled(viewModel.isLoading)

            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }
            
            ZStack {
                Divider()
                FSText(text: "or login with", fontStyle: .body14, letterSpace: 0, color: Color.fsSubtitleColor, isUnderlined: false)
                    .padding(.horizontal, 24)
                    .background(Color.white)
            }
            
            HStack {
                FSButton(icon: "apple-logo", title: "Apple", fontStyle: .bodyBold16, foregroundColor: .white, cornerRadius: 20, background: .black) {
                   
                }
                
                FSButton(icon: "google-logo", title: "Google", fontStyle: .bodyBold16, cornerRadius: 20, background: .white, borderColor: .fsPurple) {
                    
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
    }
        
    // Static factory method to create LoginView with initialized dependencies
    static func preview() -> LoginView {
        guard let client = FSClient.shared else {
            fatalError("Failed to initialize FSClient.")
        }
        
        let loginUseCase = LoginUseCase(client: client)
        let viewModel = LoginViewModel(loginUseCase: loginUseCase)
        
        return LoginView(viewModel: viewModel)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView.preview()
    }
}
