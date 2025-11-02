//
//  WorkoutItemView.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/23/24.
//

import SwiftUI
import Lottie

struct WorkoutRoutineItemView: View {
    @EnvironmentObject private var viewModel: WorkoutsViewModel
    @Binding var routine: WorkoutRoutine
    @State private var viewState: ViewState = .idle
    @State private var isUpdating: Bool = false
    
    init(routine: Binding<WorkoutRoutine>) {
        self._routine = routine
    }
    
    var horizontalInfoView: some View  {
        HStack(spacing: 10) {
            
            if let sets = routine.sets {
                IconLabelView(fsMetric: .WorkoutSet, value: sets, typography: .custom(size: 12), fontColor: .fsMutedForeground, iconSize: 12)
            }
            
            if let reps = routine.repetition {
                IconLabelView(fsMetric: .WorkoutRep, value: reps, typography: .custom(size: 12), fontColor: .fsMutedForeground, iconSize: 12)
            }
            
            if let duration = routine.duration {
                IconLabelView(fsMetric: .WorkoutTime, value: duration, typography: .custom(size: 12), fontColor: .fsMutedForeground, iconSize: 12)
            }
        }
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            videoPreview
            HStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 10) {
                    FSTextView(routine.name, typography: .p_ui_medium, lineLimit: 1)
                    horizontalInfoView
                }
                Spacer()
                checkBoxButton
            }
            .padding(.horizontal, 12)
        }
        .background(.white)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray230, lineWidth: 1)
        )
    }
    
    var videoPreview: some View {
        ZStack {
            if let videoURL = URL(string: routine.gifUrl ?? "") {
                VideoPreviewView(videoURL: videoURL)
            }
        }
        .frame(width: 80, height: 80)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    
    var checkBoxButton: some View {
        Button(action: {
            guard !routine.isCompleted else { return }
            triggerHaptics()
            withAnimation {
                routine.isCompleted = true
                viewModel.updateDailyProgress()
                viewModel.updateCalendarData()
                viewModel.objectWillChange.send()
            }
            Task {
                do {
                    try await viewModel.onToggleCompleted(for: routine.id, date: routine.date, name: routine.name)

                } catch {
                    routine.isCompleted = false
                    ToastManager.shared.showError("Something went wrong. Please try again later.", duration: 5.0)
                }
            }
        }, label: {
            Group {
                if routine.isCompleted {
                    Image(.icCheckboxSelected)
                        .resizable()
                        .frame(width: 29, height: 29)
                } else {
                    Image(.icCheckboxUnselected)
                        .resizable()
                        .frame(width: 26, height: 26)
                }
            }
            .overlay(alignment: .center) {
                if viewState == .updating {
                    LottieView(animation: .named("fs-loading"))
                      .playing(loopMode: .loop)
                      .frame(width: 32, height: 32)

                }
            }
        })
        .disabled(isUpdating)
    }
    
}
