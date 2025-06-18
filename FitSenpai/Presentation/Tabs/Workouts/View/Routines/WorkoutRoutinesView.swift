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
    @State private var selectedIdex: Int = 0
    
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                ForEach(viewModel.routines.indices.sorted(by: { viewModel.routines[$0].sortIndex < viewModel.routines[$1].sortIndex }), id: \.self) { index in
                    WorkoutRoutineItemView(routine: $viewModel.routines[index])
                        .onTapGesture {
                            self.selectedRoutine = viewModel.routines[index]
                            self.selectedIdex = index
                            triggerHaptics()
                        }
                }
            }
            .padding(.horizontal, 1)
        }
        .scrollIndicators(.hidden)
        .sheet(item: $selectedRoutine) { _ in
            WorkoutDetailView(routine: $viewModel.routines[selectedIdex])
        }
    }
}
