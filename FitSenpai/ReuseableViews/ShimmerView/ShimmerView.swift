//
//  ShimmerView.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 12/18/24.
//

import Foundation
import SwiftUI


struct ShimmerView: View {
    @State private var move = false
    
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.gray.opacity(0.3))
            .overlay(
                LinearGradient(gradient: Gradient(colors: [Color.white.opacity(0.2), Color.white.opacity(0.4), Color.white.opacity(0.2)]), startPoint: .leading, endPoint: .trailing)
                    .offset(x: move ? 300 : -300) // Animate the shimmer across the view
                    .animation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false), value: move)
            )
            .onAppear {
                move.toggle() // Start the shimmer animation
            }
    }
}
