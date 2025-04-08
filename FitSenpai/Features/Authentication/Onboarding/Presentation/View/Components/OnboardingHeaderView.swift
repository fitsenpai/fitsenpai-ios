//
//  OnboardingHeaderView.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/8/25.
//

import SwiftUI


struct OnboardingHeaderView: View {
    var progress: Double
    var hideBackButton: Bool = false
    var dismiss: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            if !hideBackButton {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.black)
                        .frame(width: 24, height: 24)
                        .padding(10)
                        .background(Circle().fill(Color.gray246))
                }
            }

            ProgressView(value: progress)
                .tint(.fsPrimary)
        }
        .frame(height: 50, alignment: .center)
        .padding(.vertical, 8)
        .padding(.horizontal, 24)
    }
}
