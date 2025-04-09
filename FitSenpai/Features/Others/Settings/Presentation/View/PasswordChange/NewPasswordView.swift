import SwiftUI

struct NewPasswordView: View {
    @Environment(\.dismiss) var dismiss
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    @State private var showNewPassword = false
    @State private var showConfirmPassword = false
    @State private var showSuccess = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 32) {
            VStack(alignment: .leading, spacing: 12) {
                Text("Enter new password")
                    .font(.bodyBold28)
                
                Text("Please enter your new password below. \nMust be at least 8 characters.")
                    .font(.body16)
                    .lineSpacing(8)
            }
            
            // New password
            RoundedBorderTextField(text: $newPassword, label: "New Password", isSecure: true, showAccessory: true, cornerRadius: 12)
            
            // Confirm password
            RoundedBorderTextField(text: $confirmPassword, label: "Confirm Password", isSecure: true, showAccessory: true, cornerRadius: 12)
            
            Spacer()
            
            FSButton(title: "Save changes", fontStyle: .bodyBold16, cornerRadius: 32) {
                showSuccess = true
            }
        }
        .padding(24)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.black)
                        .frame(width: 24, height: 24)
                        .padding(10)
                        .background(Circle().fill(Color.gray246))
                }
            }
        }
        .navigationDestination(isPresented: $showSuccess) {
            PasswordSuccessView()
        }
    }
}
