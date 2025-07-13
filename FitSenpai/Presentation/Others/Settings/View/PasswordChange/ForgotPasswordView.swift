import SwiftUI

struct ForgotPasswordView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel: AuthViewModel = .init()
    @State private var email = ""
    @State private var navigateToNewPassword = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 32) {
            VStack(alignment: .leading, spacing: 12) {
                Text("Forgot password?")
                    .font(.bodyBold28)
                
                Text("Enter your email address below to reset your password.")
                    .font(.body16)
                    .lineSpacing(8)
            }
            
            VStack(alignment: .leading, spacing: 12) {
                RoundedBorderTextField(text: $email, label: "Email", isSecure: false, showAccessory: false, cornerRadius: 12)
                    .disabled(viewModel.viewState == .loading)
                
                Spacer()
                
                FSButton(title: "Confirm", fontStyle: .bodyBold16, cornerRadius: 32) {
                    triggerHaptics()
                    onLogin()
                }
                .disabled(viewModel.viewState == .loading)
                .opacity(viewModel.viewState == .loading ? 0.5 : 1)
                .overlay(alignment: .trailing) {
                    if viewModel.viewState == .loading {
                        ProgressView()
                            .controlSize(.mini)
                            .padding(12)
                    }
                }

            }
        }
        .padding(24)
        .navigationBarBackButtonHidden()
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
        .navigationDestination(isPresented: $navigateToNewPassword) {
            NewPasswordView()
        }
    }
    
    func onLogin() {
        Task {
            do {
                try await viewModel.forgotPassword(email: email)
                dismiss()
                ToastManager.shared.showSuccess("Password reset email sent successfully. You will receive email shortly if you really have an account with us.", duration: 10)
            } catch {
                ToastManager.shared.showError("Invalid email address.", duration: 5)
            }
        }
    }
}
