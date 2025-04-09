import SwiftUI

struct PasswordSuccessView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 32) {
            VStack(alignment: .leading, spacing: 12) {
                Text("Success!")
                    .font(.bodyBold28)
                
                Text("You can now use your new password to log into your account.")
                    .font(.body16)
                    .lineSpacing(8)
            }
            
            Spacer()
            
            FSButton(title: "Back to dashboard", fontStyle: .bodyBold16, cornerRadius: 32) {
                // Dismiss all the way back to settings
                dismiss()
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
                .disabled(true)
                .opacity(0)
            }
        }
    }
}
