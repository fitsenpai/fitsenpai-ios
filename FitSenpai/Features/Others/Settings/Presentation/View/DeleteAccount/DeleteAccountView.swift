import SwiftUI

struct DeleteAccountView: View {
    @Environment(\.dismiss) var dismiss
    @State private var selectedReason: DeletionReason?
    @State private var navigateToSuccess = false
    
    enum DeletionReason: String, CaseIterable {
        case notUsing = "No longer using the app"
        case betterAlternative = "Found a better alternative"
        case expensive = "Too expensive"
        case technicalIssues = "Technical issues or bugs"
        case other = "Other"
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("Confirm account deletion")
                .font(.system(size: 28, weight: .semibold))
            
            Text("Hate to see you go! Let us know why you're deleting your account—we value your feedback.")
                .font(.system(size: 16))
                .foregroundColor(.gray)
            
            VStack(spacing: 12) {
                ForEach(DeletionReason.allCases, id: \.self) { reason in
                    Button {
                        selectedReason = reason
                    } label: {
                        HStack {
                            Text(reason.rawValue)
                                .foregroundColor(.black)
                            Spacer()
                        }
                        .padding()
                        .background {
                            if selectedReason == reason {
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.red, lineWidth: 1)
                            } else {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.gray.opacity(0.1))
                            }
                        }
                    }
                }
            }
            
            Spacer()
            
            VStack(spacing: 12) {
                Button {
                    navigateToSuccess = true
                } label: {
                    Text("Delete account")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(30)
                }
                
                Button {
                    dismiss()
                } label: {
                    Text("Cancel")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .foregroundColor(.black)
                        .cornerRadius(30)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                }
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
        .navigationDestination(isPresented: $navigateToSuccess) {
            AccountDeletedView()
        }
    }
}