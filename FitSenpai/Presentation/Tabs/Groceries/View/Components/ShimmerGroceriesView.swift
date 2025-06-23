//
//  ShimmerGroceriesView.swift
//  FitSenpai
//
//  Created by AI Assistant on 1/12/25.
//

import SwiftUI

struct ShimmerGroceriesView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Content header section shimmer
            ShimmerGroceriesContentView()
            
            // Grocery list shimmer
            ShimmerGroceryListView()
        }
    }
}

struct ShimmerGroceriesContentView: View {
    var body: some View {
        VStack(spacing: 16) {
            // Section header shimmer
            ShimmerGroceriesSectionHeaderView()
            
            // Completion bar shimmer
            ShimmerGroceriesCompletionBarView()
            
            // Date range card shimmer
            ShimmerDateRangeCardView()
        }
    }
}

struct ShimmerGroceriesSectionHeaderView: View {
    var body: some View {
        HStack(spacing: 12) {
            // "Groceries" title shimmer
            ShimmerView(cornerRadius: 4)
                .frame(width: 85, height: 24)
            
            Spacer()
            
            // Generate button shimmer (if showGenerateButton was true)
            ShimmerView(cornerRadius: 8)
                .frame(width: 30, height: 30)
        }
    }
}

struct ShimmerGroceriesCompletionBarView: View {
    var body: some View {
        VStack(spacing: 8) {
            // Progress bar shimmer
            ShimmerView(cornerRadius: 4)
                .frame(height: 4)
            
            HStack {
                // Title text shimmer (e.g., "0 of 25 items")
                ShimmerView(cornerRadius: 2)
                    .frame(width: 90, height: 16)
                
                Spacer()
                
                // Progress percentage shimmer
                ShimmerView(cornerRadius: 2)
                    .frame(width: 30, height: 16)
            }
        }
    }
}

struct ShimmerDateRangeCardView: View {
    var body: some View {
        VStack(spacing: 0) {
            // Date range text shimmer
            ShimmerView(cornerRadius: 2)
                .frame(width: 200, height: 14)
                .padding(12)
        }
        .frame(maxWidth: .infinity)
        .background(Color.fsAccent)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.1), lineWidth: 1)
        )
    }
}

struct ShimmerGroceryListView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                ForEach(0..<4, id: \.self) { _ in
                    ShimmerGroceriesSectionView()
                }
            }
            .padding(.horizontal, 1)
        }
        .scrollIndicators(.hidden)
    }
}

struct ShimmerGroceriesSectionView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Category header shimmer
            HStack {
                ShimmerView(cornerRadius: 2)
                    .frame(width: 120, height: 18)
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            
            // Grocery items shimmer
            VStack(spacing: 8) {
                ForEach(0..<Int.random(in: 3...7), id: \.self) { _ in
                    ShimmerGroceryItemView()
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .background(Color.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.1), lineWidth: 1)
        )
    }
}

struct ShimmerGroceryItemView: View {
    var body: some View {
        HStack(spacing: 12) {
            // Checkbox shimmer
            ShimmerView(cornerRadius: 4)
                .frame(width: 20, height: 20)
            
            // Item name shimmer
            ShimmerView(cornerRadius: 2)
                .frame(width: CGFloat.random(in: 80...150), height: 16)
            
            Spacer()
            
            // Quantity or additional info shimmer
            ShimmerView(cornerRadius: 2)
                .frame(width: 40, height: 14)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color.gray.opacity(0.05))
        .cornerRadius(8)
    }
}
