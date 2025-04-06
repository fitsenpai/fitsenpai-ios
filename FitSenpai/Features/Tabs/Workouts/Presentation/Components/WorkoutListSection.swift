//
//  WorkoutListSection.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/3/25.
//

import SwiftUI

struct WorkoutListSection: View {
    @ObservedObject var viewModel: WorkoutsMainViewModel
    @Binding var showingDetail: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            FSSectionHeaderView(text: "Workouts")
            FSCompletionBarView(titleText: "Upper Body", progress: 0.2)
            if viewModel.isWorkoutLoading {
                ProgressView()
            } else {
                workoutList
            }
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 24)
    }
    
    private var workoutList: some View {
        ScrollView {
            VStack(spacing: 12) {
                Color.clear.frame(height: 2)
                ForEach(viewModel.workoutPlans, id: \.id) { workout in
                    WorkoutView(
                        image: "ic_workout",
                        title: workout.name ?? "",
                        videoURL: workout.url,
                        showInfo: true,
                        isSelected: workout == viewModel.selectedWorkout
                    )
                    .onTapGesture {
                        showingDetail.toggle()
                    }
                    .frame(height: 88)
                    .sheet(isPresented: $showingDetail) {
                        WorkoutDetailView(viewModel: WorkoutDetailViewModel(routine: Routine.initTest()))
                    }
                }
            }
        }
        .scrollIndicators(.hidden)
    }
}
