import SwiftUI

struct ForgotPasswordView: View {
    @Environment(\.dismiss) var dismiss
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
            
            RoundedBorderTextField(text: $email, label: "Email", isSecure: false, showAccessory: false, cornerRadius: 12)
            
            Spacer()
            
            FSButton(title: "Get password reset link", fontStyle: .bodyBold16, cornerRadius: 32) {
                navigateToNewPassword = true
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
        .navigationDestination(isPresented: $navigateToNewPassword) {
            NewPasswordView()
        }
    }
}
