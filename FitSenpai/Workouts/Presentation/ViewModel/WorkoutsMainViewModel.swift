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
    @Published var workoutPlans: [DailyWorkoutPlan] = []
    @Published var selectedWorkout: DailyWorkoutPlan?
    @Published var selectedTargetGroup: String = "Upper Body" // example
    @Published var isWorkoutLoading: Bool = false
    @Published var weeklyPlan: WeeklyPlan?
    @Published var upNextWeekNumber: Int?
    @Published var isWeeklyPlanLoading: Bool = false
    
    // Cache for workout plans by date
    private var workoutPlanCache: [String: [DailyWorkoutPlan]] = [:]
    
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
    func fetchWorkoutPlans(forUser userId: UUID, date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let formattedDate = dateFormatter.string(from: date)
        
        // Check cache first
        if let cachedPlans = workoutPlanCache[formattedDate] {
            // If cached data exists, use it directly
            DispatchQueue.main.async {
                self.workoutPlans = cachedPlans
            }
            return
        }
        Task {
            do {
                // Make sure updates to the @Published property are dispatched on the main thread
                let fetchedWorkoutPlans = try await workoutUseCase.fetchWorkoutPlans(forUser: userId, date: date)
                
                // Ensure the update happens on the main thread
                DispatchQueue.main.async {
                    self.workoutPlans = fetchedWorkoutPlans
                    self.workoutPlanCache[formattedDate] = fetchedWorkoutPlans
                }
            } catch {
                print("Error fetching workout plans: \(error)")
            }
        }
    }
    
    // Fetch the weekly plan for the user
    func fetchWeeklyPlan(forUser userId: UUID, date: Date) {
        isWeeklyPlanLoading = true
        upNextWeekNumber = nil
        Task {
            do {
                let fetchedWeeklyPlan = try await workoutUseCase.fetchWeeklyPlan(forUser: userId, date: date)
                guard !fetchedWeeklyPlan.isEmpty else {
                    self.fetchWeekToGenerate(forUser: userId)
                    return
                }
                DispatchQueue.main.async {
                    self.weeklyPlan = fetchedWeeklyPlan.first
                    self.isWeeklyPlanLoading = false
                }
            } catch {
                print("Error fetching weekly plan: \(error)")
                DispatchQueue.main.async {
                    self.isWeeklyPlanLoading = false
                }
            }
        }
    }
    
    func fetchWeekToGenerate(forUser userId: UUID) {
        Task {
            do {
                if let weekNumber = try await workoutUseCase.fetchWeekToGenerate(forUser: userId) {
                    DispatchQueue.main.async {
                        self.upNextWeekNumber = weekNumber + 1
                        self.isWeeklyPlanLoading = false
                    }
                }else{
                    print("Error fetching next week to generate")
                    self.isWeeklyPlanLoading = false
                }
            } catch {
                print("Error fetching next week to generate: \(error)")
                DispatchQueue.main.async {
                    self.isWeeklyPlanLoading = false
                }
            }
        }
    }
    
    // Handle selection of a workout
    func selectWorkout(workout: DailyWorkoutPlan) {
        DispatchQueue.main.async {
            self.selectedWorkout = workout
        }
    }
}
