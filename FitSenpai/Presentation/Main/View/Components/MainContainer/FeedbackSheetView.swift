//
//  NegativeFeedbackSheet.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/3/25.
//

import SwiftUI

struct NegativeFeedbackSheet: View {
    @StateObject private var viewModel = FeedbackViewModel()
    @Binding var feedbackType: FeedbackType?
    @Environment(\.dismiss) private var dismiss
    @State private var selectedOption: String?
    @State var feedbackText: String = ""
    
    var category: String
    
    var body: some View {
        VStack(spacing: 20) {
            Rectangle()
                .fill(Color.gray.opacity(0.4))
                .clipShape(.rect(cornerRadius: 32))
                .frame(width: 32, height: 4)
            
            Image(.iconMessageGreen)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
            
            FSTextView("Tell us more", typography: .h3)
            
            VStack(spacing: 12) {
                HStack(spacing: 8) {
                    FeedbackOptionView(text: "Not what I expected", isSelected: $selectedOption)
                    FeedbackOptionView(text: "Too inconvenient", isSelected: $selectedOption)
                }
                HStack(spacing: 8) {
                    FeedbackOptionView(text: "Not useful", isSelected: $selectedOption)
                    FeedbackOptionView(text: "Wrong info", isSelected: $selectedOption)
                    FeedbackOptionView(text: "Other", isSelected: $selectedOption)
                }
            }
            .padding(.vertical, 16)
            
            FSButton(title: "Submit", fontStyle: .bodyBold14, cornerRadius: 32) {
                if selectedOption == "Other" {
                    feedbackType = .negativeInput
                } else {
                    Task {
                        let result = await viewModel.sendNegativeFeedback(message: selectedOption ?? "", category: category)
                        switch result {
                        case .success:
                            dismiss()
                            ToastManager.shared.showSuccess("Feedback submitted successfully", duration: 5)
                        case .failure:
                            ToastManager.shared.showSuccess("Something went wrong. Please try again later.")

                        }
                    }
                }
            }
            .disabled(selectedOption == nil || viewModel.viewState == .loading)
            .opacity(selectedOption == nil || viewModel.viewState == .loading ? 0.3 : 1)
            .overlay(alignment: .trailing) {
                if viewModel.viewState == .loading {
                    ProgressView()
                        .controlSize(.mini)
                        .padding(12)
                }
            }
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 24)
        .padding(.top, 10)
    }
}

struct NegativeFeedbackInoutSheet: View {
    @StateObject private var viewModel = FeedbackViewModel()
    @Environment(\.dismiss) private var dismiss
    @State var feedbackText: String = ""
    var category: String

    var onBackPress: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Rectangle()
                .fill(Color.gray.opacity(0.4))
                .clipShape(.rect(cornerRadius: 32))
                .frame(width: 32, height: 4)
            
            Image(.iconMessageGreen)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
            
            FSTextView("Tell us more", typography: .h3)
            
            VStack(spacing: 12) {
                TextEditor(text: $feedbackText)
                    .font(.body14)
                    .padding(12)
                    .frame(height: 88)
                    .background(
                        ZStack {
                            Color.clear
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color.fsInputBorderColor, lineWidth: 1)
                        }
                    )
                    .scrollContentBackground(.hidden)
                    .overlay(alignment: .topLeading, content: {
                        if feedbackText.isEmpty {
                            FSTextView("Let us know how we can improve this for you...", typography: .body, color: .fsMutedForeground)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 20)
                                .frame(maxWidth: .infinity, alignment: .topLeading)
                        }
                    })
            }
            .padding(.vertical, 16)
            
            HStack(spacing: 10) {
                FSButton(title: "Back", fontStyle: .bodyBold14, cornerRadius: 32, background: .gray230) {
                    onBackPress()
                }
                FSButton(title: "Submit", fontStyle: .bodyBold14, cornerRadius: 32) {
                    Task {
                        let result = await viewModel.sendNegativeFeedback(message: feedbackText, category: category)
                        switch result {
                        case .success:
                            dismiss()
                            ToastManager.shared.showSuccess("Feedback submitted successfully", duration: 5)
                        case .failure:
                            ToastManager.shared.showSuccess("Something went wrong. Please try again later.")

                        }
                    }
                }
                .disabled(feedbackText.isEmpty || feedbackText.count < 5 || viewModel.viewState == .loading)
                .opacity(feedbackText.isEmpty || feedbackText.count < 5 || viewModel.viewState == .loading ? 0.3 : 1)
                .overlay(alignment: .trailing) {
                    if viewModel.viewState == .loading {
                        ProgressView()
                            .controlSize(.mini)
                            .padding(12)
                    }
                }
            }
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 24)
        .padding(.top, 10)
    }
    
}

struct ChangeWorkoutSheetSheet: View {
    @EnvironmentObject private var superwall: SuperwallManager
    @ObservedObject var viewModel: WorkoutsViewModel
    @StateObject private var calendarManager = CalendarDataManager.shared

    @Environment(\.dismiss) private var dismiss
    @State var instructionText: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            SheetIndicator()
            Image(.iconRepeatSquare)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
            
            FSTextView("Change workouts?", typography: .h3)
            FSTextView("Get a new set of workouts for this day. Add instruction below (optional).", typography: .body, alignment: .center)

            VStack(spacing: 12) {
                TextEditor(text: $instructionText)
                    .font(.body14)
                    .padding(12)
                    .frame(height: 88)
                    .background(
                        ZStack {
                            Color.clear
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color.fsInputBorderColor, lineWidth: 1)
                        }
                    )
                    .scrollContentBackground(.hidden)
                    .overlay(alignment: .topLeading, content: {
                        if instructionText.isEmpty {
                            Text("e.g., 'I’m in my luteal phase’")
                                .font(.body14)
                                .foregroundColor(.gray)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 20)
                                .frame(maxWidth: .infinity, alignment: .topLeading)
                        }
                    })
            }
            .padding(.vertical, 16)
            
            VStack(spacing: 10) {
                FSButton(title: superwall.isTrialActive ? "Upgrade to continue" :  "Confirm", fontStyle: .bodyBold16, cornerRadius: 32) {
                    dismiss()
                    Task {
                        await viewModel.regenerateWorkoutPlan(date: calendarManager.selectedDate, instruction: instructionText)
                    }
                }
                if superwall.isTrialActive {
                    FSTextView("This feature is only available for Pro users.", typography: .detail_semi, color: .fsMutedForeground)
                }
            }
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 24)
        .padding(.top, 10)
    }
    
}

struct ChangeMealsSheetSheet: View {
    @EnvironmentObject private var superwall: SuperwallManager
    @ObservedObject var viewModel: MealsViewModel
    @StateObject private var calendarManager = CalendarDataManager.shared

    @Environment(\.dismiss) private var dismiss
    @State var instructionText: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            SheetIndicator()
            Image(.iconRepeatSquare)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
            
            FSTextView("Change meals?", typography: .h3)
            FSTextView("Get new meals for this day. Groceries will be\nupdated. Add instruction below (optional).", typography: .body, alignment: .center)

            VStack(spacing: 12) {
                TextEditor(text: $instructionText)
                    .font(.body14)
                    .padding(12)
                    .frame(height: 88)
                    .background(
                        ZStack {
                            Color.clear
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color.fsInputBorderColor, lineWidth: 1)
                        }
                    )
                    .scrollContentBackground(.hidden)
                    .overlay(alignment: .topLeading, content: {
                        if instructionText.isEmpty {
                            Text("e.g., 'No dairy today’")
                                .font(.body14)
                                .foregroundColor(.gray)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 20)
                                .frame(maxWidth: .infinity, alignment: .topLeading)
                        }
                    })
            }
            .padding(.vertical, 16)
            
            VStack(spacing: 10) {
                FSButton(title: superwall.isTrialActive ? "Upgrade to continue" :  "Confirm", fontStyle: .bodyBold16, cornerRadius: 32) {
                    dismiss()
                    Task {
                        await viewModel.regenerateMealPlan(date: calendarManager.selectedDate, instruction: instructionText)
                    }
                }
                if superwall.isTrialActive {
                    FSTextView("This feature is only available for Pro users.", typography: .detail_semi, color: .fsMutedForeground)
                }
            }
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 24)
        .padding(.top, 10)
    }
    
}
