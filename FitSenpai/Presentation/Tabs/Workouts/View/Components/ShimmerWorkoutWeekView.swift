//
//  ShimmerWorkoutWeekView.swift
//  FitSenpai
//
//  Created by AI Assistant on 1/12/25.
//

import SwiftUI

struct ShimmerWorkoutWeekView: View {
    var body: some View {
        VStack(spacing: 16) {
            ShimmerSectionHeaderView()
            ShimmerWorkoutDayView()
        }
    }
}

struct ShimmerSectionHeaderView: View {
    var body: some View {
        HStack(spacing: 12) {
            FSTextView("Workouts", typography: .h3)
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

struct ShimmerWorkoutDayView: View {
    var body: some View {
        VStack(spacing: 16) {
            ShimmerCompletionBarView()
            ShimmerWorkoutRoutinesView()
        }
    }
}

struct ShimmerCompletionBarView: View {
    var body: some View {
        VStack(spacing: 8) {
            ShimmerView(cornerRadius: 4)
                .frame(height: 4)
            HStack {
                ShimmerView(cornerRadius: 2)
                    .frame(width: 80, height: 16)
                Spacer()
                ShimmerView(cornerRadius: 2)
                    .frame(width: 30, height: 16)
            }
        }
    }
}

struct ShimmerWorkoutRoutinesView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                ForEach(0..<4, id: \.self) { _ in
                    ShimmerWorkoutRoutineItemView()
                }
            }
            .padding(.horizontal, 1)
        }
        .scrollIndicators(.hidden)
    }
}

struct ShimmerWorkoutRoutineItemView: View {
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            // Video preview shimmer
            ShimmerView(cornerRadius: 0)
                .frame(width: 80, height: 80)
            
            HStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 10) {
                    // Routine name shimmer
                    ShimmerView(cornerRadius: 4)
                        .frame(width: 150, height: 18)
                    
                    // Info view shimmer
                    HStack(spacing: 10) {
                        ShimmerView(cornerRadius: 4)
                            .frame(width: 60, height: 16)
                        ShimmerView(cornerRadius: 4)
                            .frame(width: 60, height: 16)
                        ShimmerView(cornerRadius: 4)
                            .frame(width: 60, height: 16)
                    }
                }
                Spacer()
            }
            .padding(.horizontal, 12)
        }
        .frame(height: 80)
        .background(.white)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray230, lineWidth: 1)
        )
    }
}
