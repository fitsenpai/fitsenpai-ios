import SwiftUI

struct ChangePasswordView: View {
    @Environment(\.dismiss) var dismiss
    @State private var currentPassword = ""
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    @State private var showCurrentPassword = false
    @State private var showNewPassword = false
    @State private var showConfirmPassword = false
    @State private var navigateToForgotPassword = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 32) {
            Text("Change password")
                .font(.bodyBold28)
            
            VStack(alignment: .leading, spacing: 8) {
                RoundedBorderTextField(text: $currentPassword, label: "Current Password", isSecure: true, showAccessory: true, cornerRadius: 12)
                
                Button {
                    triggerHaptics()
                    navigateToForgotPassword = true
                } label: {
                    FSText(text: "Forgot password?", fontStyle: .body14, letterSpace: 0, color: .fsMutedForeground, isUnderlined: true)
                }
            }
            
            // New password
            RoundedBorderTextField(text: $newPassword, label: "New Password", isSecure: true, showAccessory: true, cornerRadius: 12)
            
            // Confirm password
            RoundedBorderTextField(text: $confirmPassword, label: "Confirm Password", isSecure: true, showAccessory: true, cornerRadius: 12)
            
            Spacer()
            
            FSButton(title: "Save changes", fontStyle: .bodyBold16, cornerRadius: 32) {
                triggerHaptics()
                dismiss()
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
        .navigationDestination(isPresented: $navigateToForgotPassword) {
            ForgotPasswordView()
        }
    }
}
