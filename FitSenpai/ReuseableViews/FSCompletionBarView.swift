//
//  FSCompletionBarView.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/23/24.
//

import SwiftUI

struct FSCompletionBarView: View {
    var body: some View {
        VStack(spacing: 4) {
            ProgressView(value: 0.75)
                .accentColor(.fsPrimary)
            HStack {
                FSText(text: "3/7 Done", fontStyle: .mona12, color: .fsSubtitleColor)
                Spacer()
                FSText(text: "75%", fontStyle: .mona12, color: .fsSubtitleColor)
            }
        }
    }
}

#Preview {
    FSCompletionBarView()
}
