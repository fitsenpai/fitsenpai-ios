import SwiftUI

struct AccountDeletedView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "face.smiling.inverse")
                .font(.system(size: 48))
                .foregroundColor(.red)
            
            Text("Account deleted")
                .font(.system(size: 28, weight: .semibold))
            
            Text("Your account has been deleted. You can create a new account anytime if you decide to return.")
                .font(.system(size: 16))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
            
            Spacer()
            
            Button {
                // Handle create account action
                dismiss()
            } label: {
                Text("Create account")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(red: 164/255, green: 213/255, blue: 72/255))
                    .foregroundColor(.white)
                    .cornerRadius(30)
            }
        }
        .padding(24)
        .navigationBarBackButtonHidden()
    }
}