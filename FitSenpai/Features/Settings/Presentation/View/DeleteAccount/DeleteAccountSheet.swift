import SwiftUI

struct DeleteAccountSheet: View {
    @Environment(\.dismiss) var dismiss
    @State private var selectedReason: DeletionReason?
    @State private var showSuccessScreen = false
    
    enum DeletionReason: String, CaseIterable {
        case notUsing = "No longer using the app"
        case betterAlternative = "Found a better alternative"
        case expensive = "Too expensive"
        case technicalIssues = "Technical issues or bugs"
        case other = "Other"
    }
    
    var body: some View {
        if showSuccessScreen {
            accountDeletedView
        } else {
            confirmDeletionView
        }
    }
    
    private var confirmDeletionView: some View {
        NavigationView {
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
                        showSuccessScreen = true
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
            .navigationBarTitleDisplayMode(.inline)
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
        }
    }
    
    private var accountDeletedView: some View {
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
                // Navigate to create account screen
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
    }
}