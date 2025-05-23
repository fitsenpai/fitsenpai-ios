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
            if let workoutDay = viewModel.workoutDay {
                // If WorkoutRoutinesView expects a Binding<WorkoutDay> (non-optional)
                // we create it here, knowing workoutDay is currently non-nil.
                // The responsibility is on this view to remove WorkoutRoutinesView
                // if viewModel.workoutDay becomes nil again.
                WorkoutRoutinesView(viewModel: viewModel, workoutDay: Binding(
                    get: {
                        // Defensive check: If workoutDay somehow became nil despite the outer `if let`,
                        // which can happen if the view displaying WorkoutRoutinesView doesn't recompose
                        // immediately when viewModel.workoutDay turns nil, provide a default or crash explicitly.
                        // However, the outer `if let workoutDay` should generally prevent WorkoutRoutinesView
                        // from being in the hierarchy if viewModel.workoutDay is nil.
                        // If this binding's get is called and viewModel.workoutDay IS nil, it's a state issue.
                        // The most robust get for a non-optional binding from an optional source:
                        guard let currentWorkoutDay = viewModel.workoutDay else {
                            // This state should ideally not be reached if the parent view correctly
                            // manages the lifecycle of WorkoutRoutinesView based on viewModel.workoutDay.
                            // If it is reached, it means WorkoutRoutinesView is still alive
                            // while its required data went nil.
                            // Returning a default or a "dummy" WorkoutDay might be an option if
                            // WorkoutRoutinesView can handle it, but often it's better to ensure this path isn't hit.
                            // For now, let's re-assert based on the captured non-optional `workoutDay`.
                            // This assumes that once WorkoutRoutinesView is created with a valid `workoutDay`,
                            // the binding will operate on that instance's state or re-fetch if necessary.
                            // The most direct way if `workoutDay` in the binding is truly derived from `viewModel.workoutDay`
                            // is to ensure the `if let` guard above is effective.
                            // The crash implies the `if let` was true, but then `viewModel.workoutDay` became nil
                            // before the getter was called.
                            // Re-check `viewModel.workoutDay` to be absolutely safe in the getter.
                            // If it's nil now, the view should not be trying to get it.
                            // This indicates that WorkoutRoutinesView is still being asked for its body
                            // even though its data source is gone.
                            FSLogger.error("WorkoutDaysView: Binding's get called for WorkoutRoutinesView when viewModel.workoutDay is nil. This indicates a state inconsistency.")
                            // To prevent a crash here, we'd need a sensible default, but WorkoutDay is complex.
                            // The original captured 'workoutDay' from the 'if let' is the safest to return if non-optional is expected.
                            return workoutDay // Return the one captured by the `if let`
                        }
                        return currentWorkoutDay
                    },
                    set: { newItem in
                        viewModel.workoutDay = newItem
                        // viewModel.objectWillChange.send() // Usually not needed if viewModel.workoutDay is @Published
                    }
                ))
            } else {
                // Optionally, show a placeholder or an empty state view if viewModel.workoutDay is nil
                // For example: Text("No workout day selected or available.")
                // Or simply nothing, as it is now.
            }
        }
    }
}
