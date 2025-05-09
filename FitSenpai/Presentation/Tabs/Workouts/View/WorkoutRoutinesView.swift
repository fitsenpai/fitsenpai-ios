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
    @State private var selectedRoutine: Routine?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                ForEach($workoutDay.routines, id: \.id) { $routine in
                    WorkoutRoutineItemView(routine: $routine) {
                        viewModel.objectWillChange.send()
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
    }
}
