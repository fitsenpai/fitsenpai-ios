//
//  FSCard.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/5/25.
//

import SwiftUI

// MARK: - Helper Views
struct FSCard<Content: View>: View {
    let backgroundColor: Color
    let borderColor: Color
    let content: Content
    
    init(backgroundColor: Color = .white, borderColor: Color = .clear, @ViewBuilder content: () -> Content) {
        self.backgroundColor = backgroundColor
        self.borderColor = borderColor
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(12)
            .background(backgroundColor)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(borderColor, lineWidth: 1)
            )
        
    }
}
