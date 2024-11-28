//
//  WorkoutsMainViewModel.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/28/24.
//

import Foundation
import Combine

class WorkoutsMainViewModel: ObservableObject {
    private let workoutUseCase: WorkoutUseCase
    private var cancellables: Set<AnyCancellable> = []
    
    @Published var workouts: [Workout] = []
    @Published var workoutPlans: [WorkoutPlan] = []
    @Published var selectedWorkout: Workout?
    @Published var selectedTargetGroup: String = "Upper Body" // example
    @Published var isWorkoutLoading: Bool = false
    
    init(workoutUseCase: WorkoutUseCase) {
        self.workoutUseCase = workoutUseCase
    }
    
    // Fetch workouts for the main view
    func fetchWorkouts() {
        isWorkoutLoading = true
        Task {
            do {
                // Make sure updates to the @Published property are dispatched on the main thread
                let fetchedWorkouts = try await workoutUseCase.fetchAllWorkouts()
                
                // Ensure the update happens on the main thread
                DispatchQueue.main.async {
                    self.workouts = fetchedWorkouts
                    self.isWorkoutLoading = false
                }
            } catch {
                print("Error fetching workouts: \(error)")
                DispatchQueue.main.async {
                    self.isWorkoutLoading = false
                }
            }
        }
    }
    
    // Fetch workout plans for the user
    func fetchWorkoutPlans(forUser userId: UUID) {
        Task {
            do {
                // Make sure updates to the @Published property are dispatched on the main thread
                let fetchedWorkoutPlans = try await workoutUseCase.fetchWorkoutPlans(forUser: userId)
                
                // Ensure the update happens on the main thread
                DispatchQueue.main.async {
                    self.workoutPlans = fetchedWorkoutPlans
                }
            } catch {
                print("Error fetching workout plans: \(error)")
            }
        }
    }
    
    // Handle selection of a workout
    func selectWorkout(workout: Workout) {
        DispatchQueue.main.async {
            self.selectedWorkout = workout
        }
    }
}
