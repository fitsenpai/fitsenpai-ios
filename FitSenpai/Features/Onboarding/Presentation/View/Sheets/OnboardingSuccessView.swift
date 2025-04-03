//
//  OnboardingSuccessView.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/1/25.
//

import SwiftUI

struct OnboardingSuccessView: View {
    @ObservedObject var viewModel: OnboardingMainViewModel
    @Environment(\.dismiss) private var dismiss
    var onDismiss: (() -> Void)
    
    @State private var confettiScale: CGFloat = 0.5
    @State private var confettiRotation: Double = -10
    @State private var confettiOpacity: Double = 0
    
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            
            FSText(
                text: "Thanks for trusting us!",
                fontStyle: .heading28,
                alignment: .center
            )
            
            FSText(
                text: "We'll always keep your\ninformation private and secure.",
                fontStyle: .body16,
                alignment: .center
            )
            
            FSButton(
                title: "Continue",
                fontStyle: .bodyBold16,
                cornerRadius: 32,
                background: .fsPrimary
            ) {
                withAnimation(.easeInOut(duration: 0.3)) {
                    viewModel.logSelections()
                    dismiss()
                    onDismiss()
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 48)
            
            Spacer()
        }
        .background {
            Image(.confetti)
                .resizable()
                .scaledToFit()
                .padding(.horizontal, -24)
                .scaleEffect(confettiScale)
                .rotationEffect(.degrees(confettiRotation))
                .opacity(confettiOpacity)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        withAnimation(.spring(response: 1.2, dampingFraction: 0.6, blendDuration: 0.6)) {
                            confettiScale = 1
                            confettiRotation = 5
                            confettiOpacity = 1
                        }
                    }
                }
        }
    }
}

