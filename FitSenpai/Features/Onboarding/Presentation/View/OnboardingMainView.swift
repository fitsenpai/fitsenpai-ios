//
//  OnboardingView.swift
//  FitSenpai
//
//  Created by Kevin M on 3/17/25.
//

import SwiftUI

struct OnboardingMainView: View {
    @StateObject private var viewModel = OnboardingMainViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                headerView
                
                stepContent
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarHidden(true)
        .fullScreenCover(item: $viewModel.onboardingSheet) { sheet in
            switch sheet {
            case .success:
                OnboardingSuccessView(viewModel: viewModel) {
                    viewModel.logSelections()
                    dismiss()
                }
            }
        }
    }
    
    private var headerView: some View {
        HStack(spacing: 12) {
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    if viewModel.currentStepIndex > 0 {
                        viewModel.moveToPreviousStep()
                    } else {
                        dismiss()
                    }
                }
            }) {
                Image(systemName: "arrow.left")
                    .foregroundColor(.black)
                    .frame(width: 24, height: 24)
                    .padding(10)
                    .background(Circle().fill(Color.gray246))
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .foregroundColor(Color.gray.opacity(0.2))
                        .cornerRadius(12)
                        .frame(height: 6)
                    
                    Rectangle()
                        .foregroundColor(.fsPrimary)
                        .frame(width: geometry.size.width * viewModel.progress, height: 6)
                        .cornerRadius(12)
                        .animation(.easeInOut(duration: 0.3), value: viewModel.progress)
                }
            }
            .frame(height: 4)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 24)
    }
    
    @ViewBuilder
    private var stepContent: some View {
        VStack {
            VStack(alignment: .leading, spacing: 12) {
                FSText(text: viewModel.currentStep.title, fontStyle: .heading28)
                    .multilineTextAlignment(.leading)
                    .transition(
                        .asymmetric(
                            insertion: .move(edge: viewModel.isMovingForward ? .trailing : .leading)
                                .combined(with: .opacity),
                            removal: .move(edge: viewModel.isMovingForward ? .leading : .trailing)
                                .combined(with: .opacity)
                        )
                    )
                
                if let subtitle = viewModel.currentStep.subtitle {
                    FSText(text: subtitle, fontStyle: .body16)
                        .multilineTextAlignment(.leading)
                        .transition(
                            .asymmetric(
                                insertion: .move(edge: viewModel.isMovingForward ? .trailing : .leading)
                                    .combined(with: .opacity),
                                removal: .move(edge: viewModel.isMovingForward ? .leading : .trailing)
                                    .combined(with: .opacity)
                            )
                        )
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 24)
            
            Group {
                contentForStep
                    .transition(
                        .asymmetric(
                            insertion: .move(edge: viewModel.isMovingForward ? .trailing : .leading)
                                .combined(with: .opacity),
                            removal: .move(edge: viewModel.isMovingForward ? .leading : .trailing)
                                .combined(with: .opacity)
                        )
                    )
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
            withAnimation(.easeInOut(duration: 0.3)) {
                viewModel.moveToNextStep()
            }
        }
        .disabled(!viewModel.canProceed)
        .padding(.horizontal, 24)
        .padding(.bottom, 24)
        .transition(
            .asymmetric(
                insertion: .move(edge: viewModel.isMovingForward ? .trailing : .leading)
                    .combined(with: .opacity),
                removal: .move(edge: viewModel.isMovingForward ? .leading : .trailing)
                    .combined(with: .opacity)
            )
        )
    }
}

#Preview {
    OnboardingMainView()
}
