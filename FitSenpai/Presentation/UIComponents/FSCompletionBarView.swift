//
//  FSCompletionBarView.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/23/24.
//

import SwiftUI

struct FSCompletionBarView: View {
    var titleText: String
    var progress: Double
    var body: some View {
        VStack(spacing: 8) {
            ProgressView(value: progress)
                .accentColor(.fsPrimary)
                .animation(.easeInOut(duration: 0.5), value: progress)
            HStack {
                FSText(text: titleText, fontStyle: .body14, color: .fsMutedForeground)
                Spacer()
                FSText(text: "\(Int(progress * 100))%", fontStyle: .body14, color: .fsMutedForeground)
            }
        }
    }
}
