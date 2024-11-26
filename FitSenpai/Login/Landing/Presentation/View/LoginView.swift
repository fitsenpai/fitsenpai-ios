//
//  LoginView.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/20/24.
//

import SwiftUI

struct LoginView: View {
    @Binding var email: String
    @Binding var password: String
    
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
                RoundedBorderTextField(text: $email, placeholder: "Email")
                VStack (alignment: .leading, spacing: 10) {
                    RoundedBorderTextField(text: $email, placeholder: "Password", isSecure: true, showAccessory: true)
                    FSText(text: "Forgot password?", fontStyle: .subHeaderRegular, letterSpace: 1.1, color: Color.fsSubtitleColor, isUnderlined: true)
                }
            }
            .padding(.bottom, 24)
            
            FSButton(title: "Login") {
                login()
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
    
    private func login() {
        // Simulate login validation
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // Call the AppLoader singleton to present the main view
            if let window = UIApplication.shared.windows.first {
                AppLoader.shared.configure(window: window)
                AppLoader.shared.presentMainViewController()
            } else {
                print("Error: No window found.")
            }
        }
    }
}

#Preview {
    LoginView(email: .constant(""), password: .constant(""))
}
