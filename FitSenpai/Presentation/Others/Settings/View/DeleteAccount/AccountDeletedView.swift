import SwiftUI

struct AccountDeletedView: View {
    @EnvironmentObject private var appViewModel: AppViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            VStack(alignment: .center, spacing: 32) {
                Image(.iconSadSquare)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                
                Text("Account deleted")
                    .font(.bodyBold28)
                
                Text("Your account has been deleted. You can create a new account anytime if you decide to return.")
                    .font(.body14)
                    .lineSpacing(8)
            }
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
           
            Spacer()
            
            FSButton(title: "Sign up", fontStyle: .bodyBold16, cornerRadius: 32) {
                appViewModel.authState = .unauthenticated
                appViewModel.shouldSignIn = true
            }
        }
        .padding(24)
        .navigationBarBackButtonHidden()
    }
}
