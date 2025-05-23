//
//  WorkoutRoutinesView.swift
//  FitSenpai
//
//  Created by Mark Daquis on 5/9/25.
//

import SwiftUI

struct WorkoutRoutinesView: View {
    @ObservedObject var viewModel: WorkoutsViewModel
    @Binding var workoutDay: WorkoutDay
    @State private var selectedRoutine: WorkoutRoutine?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                ForEach($workoutDay.routines, id: \.id) { $routine in
                    WorkoutRoutineItemView(routine: $routine) {
                        Task { @MainActor in
                            // The change to routine.isCompleted via the binding,
                            // and the subsequent call to saveWorkoutRoutine (which might update
                            // @Published properties in viewModel or trigger its objectWillChange if dailyProgress changes)
                            // should be sufficient to trigger necessary UI updates.
                            await viewModel.saveWorkoutRoutine()
                        }
                    }
                    .onTapGesture {
                        self.selectedRoutine = routine
                        triggerHaptics()
                    }
                }
            }
            .padding(.horizontal, 1)
        }
        .scrollIndicators(.hidden)
        .sheet(item: $selectedRoutine) { routine in
            WorkoutDetailView(routine: routine)
        }
        .onAppear {
            // Sorting on appear is fine, but ensure it doesn't cause issues if routines can be reordered by user.
            // If sortIndex is stable and from backend, this is okay.
            // If this sort actually changes the array order reference that workoutDay.routines points to
            // (e.g. if it assigns workoutDay.routines = workoutDay.routines.sorted(...)),
            // that would also cause a re-render. However, Array.sort() sorts in place.
            self.workoutDay.routines.sort(by: { $0.sortIndex < $1.sortIndex })
        }
    }
}
