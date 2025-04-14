//
//  GrayPillView.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/23/24.
//

import SwiftUI

struct GrayPillView: View {
    var text: String
    var fontStyle: Font
    var cornerRadius: CGFloat = 8
    
    var body: some View {
        FSText(text: text, fontStyle: fontStyle, color: .fsMutedForeground)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(RoundedRectangle(cornerRadius: cornerRadius).fill(Color.gray246))
    }
}
