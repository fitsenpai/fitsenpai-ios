//
//  GrayPillView.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/23/24.
//

import SwiftUI

struct GrayPillView: View {
    var text: String
    var pillHeight: CGFloat
    var fontStyle: Font
    
    var body: some View {
        FSText(text: text, fontStyle: fontStyle, color: .fsSubtitleColor)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(RoundedRectangle(cornerRadius: pillHeight / 4).fill(Color.gray246))
            
    }
}

#Preview {
    GrayPillView(text: "Upper Body", pillHeight: 32, fontStyle: .body16)
}
