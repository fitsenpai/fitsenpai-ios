import SwiftUI

struct ChangePasswordView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = AuthViewModel()
    
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    @State private var showCurrentPassword = false
    @State private var showNewPassword = false
    @State private var showConfirmPassword = false
    @State private var navigateToForgotPassword = false
    
    // Validation states
    @State private var newPasswordError: String? = nil
    @State private var confirmPasswordError: String? = nil
    @State private var hasValidatedNewPassword = false
    @State private var hasValidatedConfirmPassword = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 32) {
            Text("Change password")
                .font(.bodyBold28)
            
            // New password
            RoundedBorderTextField(
                text: $newPassword, 
                label: "New Password", 
                isSecure: true, 
                showAccessory: true, 
                cornerRadius: 12,
                errorMessage: newPasswordError,
                isValid: newPasswordError == nil
            )
            .onChange(of: newPassword) { _, _ in
                if hasValidatedNewPassword {
                    validateNewPassword()
                }
                if hasValidatedConfirmPassword {
                    validateConfirmPassword()
                }
            }
            .onSubmit {
                validateNewPassword()
                hasValidatedNewPassword = true
            }
            
            // Confirm password
            RoundedBorderTextField(
                text: $confirmPassword, 
                label: "Confirm Password", 
                isSecure: true, 
                showAccessory: true, 
                cornerRadius: 12,
                errorMessage: confirmPasswordError,
                isValid: confirmPasswordError == nil
            )
            .onChange(of: confirmPassword) { _, _ in
                if hasValidatedConfirmPassword {
                    validateConfirmPassword()
                }
            }
            .onSubmit {
                validateConfirmPassword()
                hasValidatedConfirmPassword = true
            }
            
            Spacer()
            
            FSButton(title: "Save changes", fontStyle: .bodyBold16, cornerRadius: 32) {
                triggerHaptics()
                if validateAllFields() {
                    Task {
                        try await viewModel.resetPassword(password: newPassword)
                        dismiss()
                    }
                }
            }
        }
        .padding(24)
        .navigationBarBackButtonHidden()
        .navigationDestination(isPresented: $navigateToForgotPassword) {
            ForgotPasswordView()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    triggerHaptics()
                    dismiss()
                }) {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.black)
                        .frame(width: 24, height: 24)
                        .padding(10)
                        .background(Circle().fill(Color.gray246))
                }
            }
        }
        .overlay(alignment: .center) {
            if viewModel.viewState == .loading {
                ZStack {
                    Color.black.opacity(0.25)
                    ProgressView()
                }
            }
        }
    }
    
    // MARK: - Validation Methods
    
    private func validateNewPassword() {
        if newPassword.isEmpty {
            newPasswordError = "Password is required"
        } else if newPassword.count < 8 {
            newPasswordError = "Password must be at least 8 characters"
        } else if !isValidPassword(newPassword) {
            newPasswordError = "Password must contain at least one uppercase letter, one lowercase letter, and one number"
        } else {
            newPasswordError = nil
        }
    }
    
    private func validateConfirmPassword() {
        if confirmPassword.isEmpty {
            confirmPasswordError = "Please confirm your password"
        } else if confirmPassword != newPassword {
            confirmPasswordError = "Passwords do not match"
        } else {
            confirmPasswordError = nil
        }
    }
    
    private func validateAllFields() -> Bool {
        validateNewPassword()
        validateConfirmPassword()
        hasValidatedNewPassword = true
        hasValidatedConfirmPassword = true
        
        return newPasswordError == nil && confirmPasswordError == nil
    }
    
    private func isValidPassword(_ password: String) -> Bool {
        let hasUppercase = password.range(of: "[A-Z]", options: .regularExpression) != nil
        let hasLowercase = password.range(of: "[a-z]", options: .regularExpression) != nil
        let hasNumber = password.range(of: "[0-9]", options: .regularExpression) != nil
        
        return hasUppercase && hasLowercase && hasNumber
    }
}
