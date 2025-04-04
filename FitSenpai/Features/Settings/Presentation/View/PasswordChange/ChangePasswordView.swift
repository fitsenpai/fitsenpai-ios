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
        VStack(alignment: .leading, spacing: 24) {
            Text("Change password")
                .font(.system(size: 28, weight: .semibold))
            
            VStack(alignment: .leading, spacing: 24) {
                // Current password
                VStack(alignment: .leading, spacing: 8) {
                    Text("Current password")
                        .font(.system(size: 16))
                    
                    HStack {
                        if showCurrentPassword {
                            TextField("", text: $currentPassword)
                        } else {
                            SecureField("", text: $currentPassword)
                        }
                        
                        Button {
                            showCurrentPassword.toggle()
                        } label: {
                            Image(systemName: showCurrentPassword ? "eye.slash" : "eye")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                }
                
                Button("Forgot password?") {
                    navigateToForgotPassword = true
                }
                .foregroundColor(.blue)
                .font(.system(size: 14))
                
                // New password
                VStack(alignment: .leading, spacing: 8) {
                    Text("New password")
                        .font(.system(size: 16))
                    
                    HStack {
                        if showNewPassword {
                            TextField("", text: $newPassword)
                        } else {
                            SecureField("", text: $newPassword)
                        }
                        
                        Button {
                            showNewPassword.toggle()
                        } label: {
                            Image(systemName: showNewPassword ? "eye.slash" : "eye")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                }
                
                // Confirm password
                VStack(alignment: .leading, spacing: 8) {
                    Text("Confirm password")
                        .font(.system(size: 16))
                    
                    HStack {
                        if showConfirmPassword {
                            TextField("", text: $confirmPassword)
                        } else {
                            SecureField("", text: $confirmPassword)
                        }
                        
                        Button {
                            showConfirmPassword.toggle()
                        } label: {
                            Image(systemName: showConfirmPassword ? "eye.slash" : "eye")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                }
            }
            
            Spacer()
            
            FSButton(title: "Save", cornerRadius: 30) {
                // Handle password change
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
        .navigationDestination(isPresented: $navigateToForgotPassword) {
            ForgotPasswordView()
        }
    }
}