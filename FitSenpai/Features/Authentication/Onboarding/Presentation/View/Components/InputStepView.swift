//
//  InputStepView.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/1/25.
//

import SwiftUI

struct InputStepView: View {
    @ObservedObject var viewModel: OnboardingMainViewModel
    
    var body: some View {
        RoundedBorderTextField(text: $viewModel.inputText, label: "", cornerRadius: 12) .padding(.top, 16)

    }
}

struct AgeInputView: View {
    @ObservedObject var viewModel: OnboardingMainViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            Picker("", selection: $viewModel.age) {
                ForEach(14...100, id: \.self) { age in
                    FSText(text: "\(age)", fontStyle: .bodyBold20)
                        .tag(age)
                }
            }
            .pickerStyle(.wheel)
            .frame(width: 200, height: 200)
            .padding(.top, 32)
            Spacer()
        }
    }
}
