import SwiftUI

struct PasswordSuccessView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Success!")
                .font(.system(size: 28, weight: .semibold))
            
            Text("You can now use your new password to log into your account.")
                .font(.system(size: 16))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
            
            Spacer()
            
            FSButton(title: "Back to dashboard", cornerRadius: 30) {
                // Dismiss all the way back to settings
                dismiss()
            }
        }
        .padding(24)
        .navigationBarBackButtonHidden()
    }
}