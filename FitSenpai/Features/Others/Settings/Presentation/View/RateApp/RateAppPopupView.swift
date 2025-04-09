import SwiftUI

struct RateAppPopupView: View {
    @Binding var isPresented: Bool
    @State var showRatingStars = false
    @State private var rating: Int = 0
    
    var onNegativeFeedback: () -> Void
    
    var body: some View {
        VStack {
            if !showRatingStars {
                initialPromptView
            } else {
                ratingStarsView
            }
        }
        .frame(maxWidth: 270)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 10)
    }
    
    private var initialPromptView: some View {
        VStack(spacing: 24) {
            Text("Did you find Fit Senpai\nhelpful?")
                .font(.medium16)
                .multilineTextAlignment(.center)
            
            HStack(spacing: 16) {
                Button("No") {
                    isPresented = false
                    onNegativeFeedback()
                }
                .font(.bodyBold14)
                .frame(width: 100, height: 40)
                .background(Color.gray.opacity(0.1))
                .foregroundColor(.gray)
                .cornerRadius(32)
                
                Button("Yes") {
                    showRatingStars = true
                }
                .font(.bodyBold14)
                .frame(width: 100, height: 40)
                .background(Color.fsPrimary)
                .foregroundColor(.black)
                .cornerRadius(32)
            }
        }
        .padding(.vertical, 24)
    }
    
    private var ratingStarsView: some View {
        VStack(spacing: 0) {
            VStack(spacing: 8) {
                Text("Rate Fit Senpai")
                    .font(.bodyBold16)
                    .multilineTextAlignment(.center)
                
                Text("Tap a star to rate it on the\nApp Store.")
                    .font(.medium14)
                    .multilineTextAlignment(.center)
            }
            .padding(.vertical, 24)
            
            VStack(spacing: 12) {
                Divider()
                    .frame(maxWidth: .infinity)
                
                HStack(spacing: 8) {
                    ForEach(1...5, id: \.self) { star in
                        Image(systemName: rating >= star ? "star.fill" : "star")
                            .font(.system(size: 24))
                            .foregroundColor(.blue)
                            .onTapGesture {
                                Task {
                                    await handleRating(star)
                                }
                            }
                    }
                }
                
                Divider()
                    .frame(maxWidth: .infinity)
                
                Button("Not now") {
                    isPresented = false
                }
                .foregroundColor(.blue)
                .padding(.bottom, 12)
            }
        }
    }
    
    private func handleRating(_ rating: Int) async {
        self.rating = rating
        try? await Task.sleep(for: .seconds(1))
        isPresented = false
        if rating >= 4 {
            // Open App Store
            if let appStoreURL = URL(string: "https://apps.apple.com/app/idYOUR_APP_ID") {
                await UIApplication.shared.open(appStoreURL)
            }
        } else {
            onNegativeFeedback()
        }
    }
}
