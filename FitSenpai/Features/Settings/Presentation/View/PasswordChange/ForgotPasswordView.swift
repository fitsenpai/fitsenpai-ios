import SwiftUI

struct ForgotPasswordView: View {
    @Environment(\.dismiss) var dismiss
    @State private var email = ""
    @State private var navigateToNewPassword = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("Forgot password?")
                .font(.system(size: 28, weight: .semibold))
            
            Text("Please enter your email address below to verify your account.")
                .font(.system(size: 16))
                .foregroundColor(.gray)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Email")
                    .font(.system(size: 16))
                
                TextField("", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
            }
            
            Spacer()
            
            FSButton(title: "Continue", cornerRadius: 30) {
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
