import SwiftUI

struct RateAppPopupView: View {
    @Binding var isPresented: Bool
    @State private var showRatingStars = false
    @State private var rating: Int = 0
    
    var body: some View {
        VStack(spacing: 24) {
            if !showRatingStars {
                initialPromptView
            } else {
                ratingStarsView
            }
        }
        .frame(width: 300)
        .padding(24)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 10)
    }
    
    private var initialPromptView: some View {
        VStack(spacing: 24) {
            Text("Did you find Fit Senpai helpful?")
                .font(.system(size: 16, weight: .medium))
                .multilineTextAlignment(.center)
            
            Text("Help us improve your fitness journey.")
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
            
            HStack(spacing: 16) {
                Button("No") {
                    // Show feedback form or contact support
                    isPresented = false
                }
                .frame(width: 100)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(25)
                
                Button("Yes") {
                    showRatingStars = true
                }
                .frame(width: 100)
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(25)
            }
        }
    }
    
    private var ratingStarsView: some View {
        VStack(spacing: 24) {
            Text("Rate Fit Senpai")
                .font(.system(size: 16, weight: .medium))
                .multilineTextAlignment(.center)
            
            Text("Tap a star to rate it on the App Store.")
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
            
            HStack(spacing: 8) {
                ForEach(1...5, id: \.self) { star in
                    Image(systemName: rating >= star ? "star.fill" : "star")
                        .font(.system(size: 24))
                        .foregroundColor(rating >= star ? .yellow : .gray)
                        .onTapGesture {
                            rating = star
                            handleRating(star)
                        }
                }
            }
            
            Button("Not now") {
                isPresented = false
            }
            .foregroundColor(.blue)
            .padding(.top, 8)
        }
    }
    
    private func handleRating(_ rating: Int) {
        if rating >= 4 {
            // Open App Store
            if let appStoreURL = URL(string: "https://apps.apple.com/app/idYOUR_APP_ID") {
                UIApplication.shared.open(appStoreURL)
            }
        }
        isPresented = false
    }
}