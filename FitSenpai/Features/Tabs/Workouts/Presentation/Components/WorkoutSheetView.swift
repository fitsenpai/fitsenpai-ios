//
//  NegativeFeedbackSheet.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/3/25.
//

import SwiftUI

struct NegativeFeedbackSheet: View {
    @Binding var feedbackType: FeedbackType?
    @Environment(\.dismiss) private var dismiss
    @State private var selectedOption: String?
    @State var feedbackText: String = ""
    
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
                    dismiss()
                }
            }
            .disabled(selectedOption == nil)
            .opacity(selectedOption == nil ? 0.3 : 1)
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 24)
        .padding(.top, 10)
    }
}

struct NegativeFeedbackInoutSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State var feedbackText: String = ""
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
                    dismiss()
                }
                .disabled(feedbackText.isEmpty)
                .opacity(feedbackText.isEmpty ? 0.3 : 1)
            }
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 24)
        .padding(.top, 10)
    }
    
}

struct ChangeWorkoutSheetSheet: View {
    @AppState(\.isLimited) private var isLimitedAccess: Bool
    @Environment(\.dismiss) private var dismiss
    @State var instructionText: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            SheetIndicator()
            Image(.iconRepeatSquare)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
            
            FSText(text: "Change workouts?", fontStyle: .heading25)
            FSText(text: "Get a new set of workouts for this day. Add instruction below (optional).", fontStyle: .body14, lineSpacing: 8, alignment: .center)
            
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
            
            VStack(spacing: 5) {
                FSButton(title: isLimitedAccess ? "Upgrade to continue" :  "Confirm", fontStyle: .bodyBold14, cornerRadius: 32) {
                    dismiss()
                }
                if isLimitedAccess {
                    FSTextView("This feature is only available for Pro users.", typography: .detail_semi, color: .fsMutedForeground)
                }
            }
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 24)
        .padding(.top, 10)
    }
    
}
