//
//  OnboardingView.swift
//  FitSenpai
//
//  Created by Kevin M on 3/17/25.
//

import SwiftUI

struct OnboardingMainView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @StateObject private var viewModel = OnboardingMainViewModel()
    @Environment(\.dismiss) private var dismiss
    
    @AppState(\.accessToken) private var accessToken: String?
    
    func onDismiss() {
        withAnimation(.easeInOut(duration: 0.3)) {
            if viewModel.currentStepIndex > 0 {
                triggerHaptics()
                viewModel.moveToPreviousStep()
            } else {
                dismiss()
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                OnboardingHeaderView(progress: viewModel.progress) { onDismiss() }
                stepContent
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarHidden(true)
        .fullScreenCover(item: $viewModel.onboardingSheet) { sheet in
            switch sheet {
            case .success:
                OnboardingSuccessView(viewModel: viewModel) {
                   
                    appViewModel.userProfile = viewModel.createProfile()
                    appViewModel.userProfile?.printLogs()
                    dismiss()
                    Task {
                        await appViewModel.createLimitedWorkoutPlan()
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private var stepContent: some View {
        VStack {
            VStack(alignment: .leading, spacing: 12) {
                FSTextView(viewModel.currentStep.title, typography: .h2, alignment: .leading)
                    .transition(.opacity)
                    
                if let subtitle = viewModel.currentStep.subtitle {
                    FSTextView(subtitle, typography: .p, alignment: .leading)
                        .transition(.opacity)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 24)
            
            Group {
                contentForStep
                    .transition(.opacity)
            }
            .padding(.horizontal, 24)
            
            Spacer()
            
            if viewModel.currentStep.showsButton {
                continueButton
            }
        }
    }
    
    @ViewBuilder
    private var contentForStep: some View {
        switch viewModel.currentStep.type {
        case .selection(let showsButton):
            if showsButton {
                MultipleSelectionListView(
                    items: viewModel.currentStep.options,
                    selectedItems: $viewModel.selectedOptions,
                    onSelection: viewModel.handleMultipleSelection
                )
                .padding(.top, 32)
            } else {
                SingleSelectionListView(
                    items: viewModel.currentStep.options,
                    selectedItems: $viewModel.selectedOptions,
                    onSelection: viewModel.handleSingleSelection,
                    viewModel: viewModel
                )
                .padding(.top, 32)
            }
           
        case .heightWeight:
            HeightWeightView(viewModel: viewModel)
                .padding(.top, 32)
        case .age:
            AgeInputView(viewModel: viewModel)
                .padding(.top, 32)
        case .macro:
            MacroBreakdownView(
                calories: viewModel.macroCalories,
                protein: viewModel.macroProtein,
                carbs: viewModel.macroCarbs,
                fat: viewModel.macroFat
            )
            .padding(.top, 32)
            .onAppear {
                viewModel.calculateMacros()
            }
        case .testimonial:
            OnboardingTestimonialView()
        case .notification:
            NotificationsStepView(viewModel: viewModel)
        case .saveMoney:
            SaveMoneyView()
                .padding(.top, 24)
        case .enableNnotification:
            EnableNotifStepView(viewModel: viewModel)
        case .input:
            InputStepView(viewModel: viewModel)
                .padding(.top, 32)
        }
    }
    
    private var continueButton: some View {
        FSButton(
            title: viewModel.currentStep.buttonTitle ?? "Continue",
            fontStyle: .bodyBold16,
            cornerRadius: 32,
            background: viewModel.canProceed ? .fsPrimary : .gray.opacity(0.3)
        ) {
            triggerHaptics()
            withAnimation(.easeInOut(duration: 0.3)) {
                viewModel.moveToNextStep()
            }
        }
        .disabled(!viewModel.canProceed)
        .padding(.horizontal, 24)
        .padding(.bottom, 24)
    }
}

#Preview {
    OnboardingMainView()
}
