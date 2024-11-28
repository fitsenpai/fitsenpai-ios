//
//  WorkoutsMainView.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/22/24.
//

import SwiftUI

struct WorkoutsMainView: View {
    @StateObject var viewModel: WorkoutsMainViewModel
    
    var listingHeader: some View {
        HStack(spacing: 12) {
            Image("ic_barbel_green")
                .resizable()
                .frame(width: 32, height: 32)
            FSText(text: "Today's workout", fontStyle: .headers20, color: .fsTitle)
            Spacer()
        }
    }
    
    var targetGroupHorizontalList: some View {
        HStack (spacing: 12) {
            GrayPillView(text: viewModel.selectedTargetGroup, pillHeight: 32, fontStyle: .body16)
            Spacer()
        }
    }
    
    var workoutSection: some View {
        VStack(spacing: 16) {
            VStack {
                listingHeader
                targetGroupHorizontalList
            }
            FSCompletionBarView()
            
            if viewModel.isWorkoutLoading {
                ProgressView() // Show loading indicator while fetching
            } else {
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(viewModel.workouts, id: \.id) { workout in
                            WorkoutView(image: "ic_workout", title: workout.exerciseName, isSelected: workout == viewModel.selectedWorkout, showInfo: true)
                                .onTapGesture {
                                    viewModel.selectWorkout(workout: workout)
                                }
                                .frame(height: 88)
                        }
                        .padding(.horizontal, 1)
                    }
                }
            }
        }
        .padding(.vertical, 16)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            FSText(text: "Workout planner", fontStyle: .headers24, color: .fsTitle)
            SwipeableCalendarView()
            
            workoutSection
        }
        .padding(.horizontal, 16)
        .onAppear {
            // Assuming we want to fetch workouts when the view appears
            if let uuid = globalAppEnvObject.user?.id {
                viewModel.fetchWorkoutPlans(forUser: uuid)
            }
            
        }
    }
    
    static func create() -> WorkoutsMainView {
        let repo = WorkoutRepoImpl(client: FSClient.shared!)
        let useCase = WorkoutUseCase(workoutRepo: repo)
        let viewModel = WorkoutsMainViewModel(workoutUseCase: useCase)
        return WorkoutsMainView(viewModel: viewModel)
    }
}

struct WorkoutsMainView_Previews: PreviewProvider {
    static var previews: some View {
        let repo = WorkoutRepoImpl(client: FSClient.shared!)
        let useCase = WorkoutUseCase(workoutRepo: repo)
        let viewModel = WorkoutsMainViewModel(workoutUseCase: useCase)
        WorkoutsMainView(viewModel: viewModel)
    }
}
