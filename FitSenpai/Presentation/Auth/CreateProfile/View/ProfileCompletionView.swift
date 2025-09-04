//
//  OnboardingSuccessView.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/1/25.
//

import SwiftUI

struct ProfileCompletionView: View {
    @EnvironmentObject var appVM: AppViewModel
    @StateObject var viewModel: ProfileCompletionViewModel = ProfileCompletionViewModel()
    @Environment(\.dismiss) private var dismiss
    
    @State private var viewState: ViewState = .idle
    @State private var confettiScale: CGFloat = 0.5
    @State private var confettiRotation: Double = -10
    @State private var confettiOpacity: Double = 0
    @State private var textOpacity: Double = 0
    
    func errorViewModel(error: Error) -> FSInfoViewModel {
        .init(
            iconName: .iconBoxWarning,
            title: "An Error Occurred",
            mainLabel: error.localizedDescription,
            buttonLabel: "Retry",
            buttonAction: {
                Task {
                    triggerHaptics()
                    await onRetry()
                }
            }
        )
    }
    
    var profile: UserProfile
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                CreateProfileHeaderView(progress: viewModel.overallProgress, hideBackButton: true) { }
                switch viewState {
                case .idle:
                    contentView
                case .error(let error):
                    errorView(error)
                default:
                    EmptyView()
                }
                
            }
        }
    }
    
    private var contentView: some View {
        VStack(spacing: 50) {
            Spacer()

            VStack(spacing: 16) {
                FSTextView("Thanks for trusting us!", typography: .h2, alignment: .center)
                FSTextView("We'll always keep your\ninformation private and secure.", typography: .p_ui, alignment: .center)
            }
            
            FSButton(
                title: "Continue",
                fontStyle: .bodyBold16,
                cornerRadius: 32,
                background: .fsPrimary
            ) {
                Task {
                    await createProfile()
                }
            }
            .padding(.horizontal, 24)
            
            Spacer()
        }
        .opacity(textOpacity)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.spring(response: 1.2, dampingFraction: 0.6, blendDuration: 0.6)) {
                    textOpacity = 1
                }
            }
        }
        .background {
            confettiView
                .opacity(viewModel.showLoading ? 0 : 1)
        }
        .overlay(content: {
            if viewModel.showLoading {
                FSLoading(config: $viewModel.loadingConfiguration)
                    .background(.white)
                
            }
        })
    }
    
    private var confettiView: some View {
        Image(.confetti)
            .resizable()
            .scaledToFit()
            .padding(.horizontal, -12)
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
    
    private func errorView(_ error: Error) -> some View {
        VStack {
            Spacer()
            FSInfoView(viewModel: errorViewModel(error: error))
                .padding(.horizontal, 24)
            Spacer()
        }
    }
    
    private func createProfile() async {
        do {
            try await viewModel.createLimitedWorkoutPlan(profile: profile)
            appVM.startTrial()
        } catch {
            viewState = .error(error)
        }
    }
    
    private func onRetry() async {
        // this is for retry view
        viewState = .idle
        await createProfile()
    }
}


enum GenerateLoadingState {
    case generatingWorkout
    case generatingMeals
    case generatingGroceries
    
    var loadingConfig: FSLoadingConfig {
        let title = "Getting everything \nready for you"
        switch self {
        case .generatingWorkout:
            return .init(title: title, subtitle: "Customizing your workout plan...")
        case .generatingMeals:
            return .init(title: title, subtitle: "Customizing your meal plan...")
        case .generatingGroceries:
            return .init(title: title, subtitle: "Preparing your grocery list...")
        }
    }
}
