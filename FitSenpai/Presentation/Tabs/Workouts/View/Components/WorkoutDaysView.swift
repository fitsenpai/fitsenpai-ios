//
//  WorkoutDaysView.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/3/25.
//

import SwiftUI


struct WorkoutDaysView: View {
    @EnvironmentObject private var superwall: SuperwallManager
    @ObservedObject var viewModel: WorkoutsViewModel
    
    var title: String { viewModel.workoutDay?.title ?? "" }
    
    var body: some View {
        VStack(spacing: 16) {
            FSSectionHeaderView(text: "Workouts") {
                triggerHaptics()
                if superwall.isFirstDayTrialActive {
                    superwall.presentPaywall(for: .proContent)
                } else {
                    viewModel.activeSheet = .changeWorkout
                }
            }
            
            FSCompletionBarView(titleText: title, progress: viewModel.dailyProgress)
            if let _ = viewModel.workoutDay {
                WorkoutRoutinesView(viewModel: viewModel, workoutDay: Binding(
                    get: { viewModel.workoutDay! },
                    set: { newItem in
                        viewModel.workoutDay = newItem
                        viewModel.objectWillChange.send()
                    }
                ))
            }
        }
    }
}
