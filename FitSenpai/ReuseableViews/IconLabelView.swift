//
//  IconLabelView.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/23/24.
//

import SwiftUI

struct IconLabelView: View {
    var fsMetric: FSMetric
    var value: Int
    var fontStyle: Font
    var fontColor: Color
    var iconSize: CGFloat
    
    var body: some View {
        HStack(spacing: 4) {
            Image(fsMetric.getInfoForIcon(value).iconName)
                .resizable()
                .frame(width: iconSize, height: iconSize)
                .scaledToFit()
            FSText(text: fsMetric.getInfoForIcon(value).description, fontStyle: fontStyle, color: fontColor)
        }
    }
}

#Preview {
    IconLabelView(fsMetric: .WorkoutRep, value: 12, fontStyle: .body12, fontColor: .fsSubtitleColor, iconSize: 12)
}
