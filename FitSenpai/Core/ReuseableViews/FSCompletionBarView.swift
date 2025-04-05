//
//  FSCompletionBarView.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/23/24.
//

import SwiftUI

struct FSCompletionBarView: View {
    var body: some View {
        VStack(spacing: 8) {
            ProgressView(value: 0.2)
                .accentColor(.fsPrimary)
            HStack {
                FSText(text: "Upper Body", fontStyle: .body14, color: .fsSubtitleColor)
                Spacer()
                FSText(text: "75%", fontStyle: .body14, color: .fsSubtitleColor)
            }
        }
    }
}

#Preview {
    FSCompletionBarView()
}
