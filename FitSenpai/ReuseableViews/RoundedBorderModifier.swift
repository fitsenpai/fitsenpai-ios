//
//  RoundedBorderModifier.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 12/17/24.
//

import Foundation
import SwiftUI

struct RoundedBorderModifier: ViewModifier {
    var cornerRadius: CGFloat
    var lineWidth: CGFloat
    var borderColor: Color
    
    func body(content: Content) -> some View {
        content
            .padding(lineWidth) // Add padding based on border thickness
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(borderColor, lineWidth: lineWidth)
            )
    }
}

extension View {
    /// Easily apply a rounded rectangle border
    func roundedBorder(cornerRadius: CGFloat = 8,
                       lineWidth: CGFloat = 1,
                       borderColor: Color = Color.gray) -> some View {
        self.modifier(RoundedBorderModifier(cornerRadius: cornerRadius,
                                            lineWidth: lineWidth,
                                            borderColor: borderColor))
    }
}
