//
//  FSSectionHeaderView.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/6/25.
//

import SwiftUI

struct FSSectionHeaderView: View {
    @Environment(\.requestReview) var requestReview
    let text: String
    var showGenerateButton: Bool = true
    @State private var feedbackType: FeedbackType?
    @State private var showRateApp: Bool = false
    
    var regenerateAction: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            FSTextView(text, typography: .h3)
            Spacer()
            HStack(spacing: 15) {
                if showGenerateButton {
                    regenerateButton
                }
                feedbackButtons
            }
            .frame(height: 16)
        }
        .fullScreenCover(isPresented: $showRateApp) {
            ZStack {
                Color.black.opacity(0.1)
                    .ignoresSafeArea()
                    .onTapGesture {
                        showRateApp.toggle()
                    }
                RateAppPopupView(showRatingStars: true) {
                    feedbackType = .negative
                }
            }
            .background(BackgroundClearView())
        }
        .sheet(item: $feedbackType, content: { type in
            switch type {
            case .negative:
                NegativeFeedbackSheet(feedbackType: $feedbackType)
                    .flexibleSheet()
                    .background(.white)
                    .presentationCornerRadius(32)
            case .negativeInput:
                NegativeFeedbackInoutSheet {
                    feedbackType = .negative
                }
                    .flexibleSheet()
                    .background(.white)
                    .presentationCornerRadius(32)
            }
        })
        
    }
    
    private var feedbackButtons: some View {
        Group {
            Button {
                feedbackType = .negative
                triggerHaptics()
            } label: {
                Image(.icThumbsUp)
                    .resizable()
                    .frame(width: 20, height: 20)
            }
            
            Button {
                requestReview()
                triggerHaptics()
            } label: {
                Image(.icThumbsUp)
                    .resizable()
                    .frame(width: 20, height: 20)
            }
        }
    }
    
    private var regenerateButton: some View {
        Button {
            regenerateAction()
        } label: {
            Image(.icRegenerate)
                .resizable()
                .frame(width: 20, height: 20)
        }
    }
    
}
