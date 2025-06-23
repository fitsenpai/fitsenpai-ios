//
//  WorkoutRoutinesView.swift
//  FitSenpai
//
//  Created by Mark Daquis on 5/9/25.
//

import SwiftUI

struct WorkoutRoutinesView: View {
    @EnvironmentObject private var viewModel: WorkoutsViewModel
    @State private var selectedRoutine: WorkoutRoutine?
    
    private var sortedRoutines: [WorkoutRoutine] {
        viewModel.routines.sorted(by: { $0.sortIndex < $1.sortIndex })
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                ForEach(sortedRoutines, id: \.id) { routine in
                    WorkoutRoutineItemView(routine: binding(for: routine))
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
            WorkoutDetailView(routine: binding(for: routine))
        }
    }
    
    private func binding(for routine: WorkoutRoutine) -> Binding<WorkoutRoutine> {
        guard let index = viewModel.routines.firstIndex(where: { $0.id == routine.id }) else {
            return .constant(routine)
        }
        return $viewModel.routines[index]
    }
}
