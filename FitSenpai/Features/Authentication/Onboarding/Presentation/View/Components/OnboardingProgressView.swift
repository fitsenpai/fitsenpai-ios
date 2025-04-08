//
//  OnboardingProgressView.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/8/25.
//

import SwiftUI

struct OnboardingProgressView: View {
    var progress: CGFloat
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(Color.gray.opacity(0.2))
                    .cornerRadius(12)
                    .frame(height: 6)
                
                Rectangle()
                    .foregroundColor(.fsPrimary)
                    .frame(width: geometry.size.width * progress, height: 6)
                    .cornerRadius(12)
                    .animation(.easeInOut(duration: 0.3), value: progress)
            }
        }
        .frame(height: 4)
    }
}
