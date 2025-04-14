//
//  EnableNotifStepView.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/2/25.
//


import SwiftUI

struct EnableNotifStepView: View {
    @ObservedObject var viewModel: OnboardingMainViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            
            FSText(text: "Stay on track with ease", fontStyle: .heading28, alignment: .center)
            
            FSText(text: "Enable notifications anytime in the settings to get smart alerts.", fontStyle: .body16, alignment: .center)
            
            FSButton(
                title: "Continue",
                fontStyle: .bodyBold16,
                cornerRadius: 32,
                background: .fsPrimary
            ) {
                viewModel.showOnboardingSheet(.success)
            }
            .padding(.horizontal, 24)
            .padding(.top, 48)
            
            Spacer()
        }
    }
}
