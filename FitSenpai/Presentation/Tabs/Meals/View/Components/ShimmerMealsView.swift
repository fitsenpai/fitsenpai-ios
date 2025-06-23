//
//  ShimmerMealsView.swift
//  FitSenpai
//
//  Created by AI Assistant on 1/12/25.
//

import SwiftUI

struct ShimmerMealsView: View {
    let columns = [
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8)
    ]
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 16) {
                // Section header shimmer
                ShimmerMealsSectionHeaderView()
                
                // Macros grid shimmer
                ShimmerMacrosGridView()
            }
            
            // Meals list shimmer
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(0..<5, id: \.self) { _ in
                        ShimmerMealItemView()
                    }
                }
                .padding(.horizontal, 1)
            }
        }
    }
}

struct ShimmerMealsSectionHeaderView: View {
    var body: some View {
        HStack(spacing: 12) {
            FSTextView("Meals", typography: .h3)
            Spacer()
            HStack(spacing: 15) {
                Button {
                    triggerHaptics()
                    // Add regenerate workout functionality here if needed
                } label: {
                    Image(.icRegenerate)
                        .resizable()
                        .frame(width: 20, height: 20)
                }
                
                Button {
                    triggerHaptics()
                    // Add thumbs down functionality here if needed
                } label: {
                    Image(.icThumbsDown)
                        .resizable()
                        .frame(width: 20, height: 20)
                }
                
                Button {
                    triggerHaptics()
                    // Add thumbs up functionality here if needed
                } label: {
                    Image(.icThumbsUp)
                        .resizable()
                        .frame(width: 20, height: 20)
                }
            }
            .frame(height: 16)
            .disabled(true)
        }
    }
}

struct ShimmerMacrosGridView: View {
    let columns = [
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8)
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(0..<4, id: \.self) { _ in
                ShimmerMacrosItemView()
            }
        }
    }
}

struct ShimmerMacrosItemView: View {
    var body: some View {
        HStack {
            // Macro name shimmer
            ShimmerView(cornerRadius: 2)
                .frame(width: 50, height: 16)
            
            Spacer()
            
            // Value shimmer with icon space
            HStack(spacing: 4) {
                ShimmerView(cornerRadius: 8)
                    .frame(width: 16, height: 16)
                ShimmerView(cornerRadius: 2)
                    .frame(width: 30, height: 16)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity, minHeight: 40)
        .background {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.1))
        }
    }
}

struct ShimmerMealItemView: View {
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            // Meal image shimmer
            ShimmerView(cornerRadius: 8)
                .frame(width: 80, height: 80)
            
            VStack(alignment: .leading, spacing: 8) {
                // Meal type shimmer
                ShimmerView(cornerRadius: 2)
                    .frame(width: 80, height: 14)
                
                // Meal name shimmer
                ShimmerView(cornerRadius: 2)
                    .frame(width: 150, height: 18)
                
                // Macros info shimmer
                HStack(spacing: 12) {
                    ShimmerView(cornerRadius: 2)
                        .frame(width: 60, height: 14)
                    ShimmerView(cornerRadius: 2)
                        .frame(width: 60, height: 14)
                    ShimmerView(cornerRadius: 2)
                        .frame(width: 60, height: 14)
                }
            }
            
            Spacer()
            
            // Chevron or action button shimmer
            ShimmerView(cornerRadius: 2)
                .frame(width: 8, height: 14)
        }
        .padding(12)
        .background(Color.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.1), lineWidth: 1)
        )
    }
}
