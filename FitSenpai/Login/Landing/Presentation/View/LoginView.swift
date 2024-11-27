//
//  LoginView.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/20/24.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel: LoginViewModel

    init(viewModel: LoginViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            ZStack {
                Color.fsAccent
                    .clipShape(RoundedCorner(radius: 7.5, corners: .allCorners))
                    .frame(width: 40, height: 40)
                Image("ic_user_circle")
                    .resizable()
                    .frame(width: 25, height: 25)
            }

            VStack(alignment: .leading, spacing: 8) {
                FSText(text: "Welcome back", fontStyle: .headers, color: .fsTitle)
                FSText(text: "Login to access your fitness plans", fontStyle: .body14, color: .fsSubtitleColor)
            }

            VStack(spacing: 24) {
                RoundedBorderTextField(text: $viewModel.email, placeholder: "Email")
                VStack(alignment: .leading, spacing: 10) {
                    RoundedBorderTextField(text: $viewModel.password, placeholder: "Password", isSecure: true, showAccessory: true)
                    FSText(text: "Forgot password?", fontStyle: .subHeaderRegular, letterSpace: 1.1, color: Color.fsSubtitleColor, isUnderlined: true)
                }
            }
            .padding(.bottom, 24)

            FSButton(title: viewModel.isLoading ? "Logging in..." : "Login") {
                Task {
                    await viewModel.login()
                }
            }
            .disabled(viewModel.isLoading)

            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }

            Spacer()

            HStack(spacing: 2) {
                Spacer()
                FSText(text: "Don't have an account?", fontStyle: .body14, color: .fsTitle)
                FSText(text: "Sign up here", fontStyle: .fieldsHeader, color: .fsAccentForeground)
                Spacer()
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 63)
        .navigationBarBackButtonHidden()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        let client = FSClient.shared!
        let loginUseCase = LoginUseCase(client: client)
        let viewModel = LoginViewModel(loginUseCase: loginUseCase)

        LoginView(viewModel: viewModel)
    }
}
