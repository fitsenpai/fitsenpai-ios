import SwiftUI
import CoreKit

struct DeleteAccountView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = AuthViewModel()
    @State private var selectedReason: DeletionReason = .other
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
            VStack(alignment: .leading, spacing: 12) {
                Text("Confirm account deletion")
                    .font(.bodyBold28)
                
                Text("Hate to see you go! Let us know why you're \ndeleting your account—we value your feedback.")
                    .font(.body14)
                    .lineSpacing(8)
            }
            
            VStack(spacing: 14) {
                ForEach(DeletionReason.allCases, id: \.self) { reason in
                    Button {
                        triggerHaptics()
                        selectedReason = reason
                    } label: {
                        HStack {
                            FSText(text: reason.rawValue, fontStyle: selectedReason == reason ? .bodyBold16 : .body16)
                            
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
                
                FSButton(title: "Delete account", fontStyle: .bodyBold16, foregroundColor: .white, cornerRadius: 32, background: .red) {
                    
                    triggerHaptics()
                    Task {
                        do {
                            try await viewModel.deleteAccount(feedback: selectedReason.rawValue)
                            NetworkSession.shared.clearTokens()
                            navigateToSuccess = true
                        }
                    }
                }
                
                FSButton(title: "Cancel", fontStyle: .bodyBold16, foregroundColor: .gray156, cornerRadius: 32, background: .white, borderColor: .gray156) {
                    triggerHaptics()
                    dismiss()
                }
            }
        }
        .padding(24)
        .navigationBarBackButtonHidden()
        .navigationDestination(isPresented: $navigateToSuccess) {
            AccountDeletedView()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    triggerHaptics()
                    dismiss()
                }) {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.black)
                        .frame(width: 24, height: 24)
                        .padding(10)
                        .background(Circle().fill(Color.gray246))
                }
            }
        }
        .overlay(alignment: .center) {
            if viewModel.viewState == .loading {
                ZStack {
                    Color.black.opacity(0.25)
                    ProgressView()
                }
            }
        }
    }
}
