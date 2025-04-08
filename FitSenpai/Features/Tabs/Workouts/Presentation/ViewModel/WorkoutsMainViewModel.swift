//
//  WorkoutsMainViewModel.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/28/24.
//

import Foundation
import Combine

@MainActor
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
    @Published var showGeneratePlan: Bool = true
    @Published var showingDetail = false
    @Published var activeSheet: WorkoutSheet?
    
    // Cache for workout plans by date
    private var workoutPlanCache: [String: [DailyWorkoutPlan]] = [:]
    private var weeklyPlanCache: [String: WeeklyPlan] = [:]
    private var fetchAttempted: Set<String> = [] // Tracks keys for which a fetch was attempted
    
    private var workoutCache: [String: [Workout]?] = [:] // Cache for workouts
    private var fetchWorkoutsAttempted = false // Tracks if fetchWorkouts was attempted
    
    init(workoutUseCase: WorkoutUseCase) {
        self.workoutUseCase = workoutUseCase
    }
    
    func generateWorkputPlan() async -> ([Date: Double], Set<Int>) {
        isWorkoutLoading.toggle()
        try? await Task.sleep(nanoseconds: 5_000_000_000)
        isWorkoutLoading.toggle()
        showGeneratePlan.toggle()
        let progressDate = [
            // Today with 50% progress
            Date(): 0.5,
            
            // Tomorrow with 30% progress
            Calendar.current.date(byAdding: .day, value: 2, to: Date())!: 0.3,
            
            // Day after tomorrow with 80% progress
            Calendar.current.date(byAdding: .day, value: 4, to: Date())!: 0.8,
            Calendar.current.date(byAdding: .day, value: 5, to: Date())!: 0.1,
            
            // Tomorrow with 30% progress
            Calendar.current.date(byAdding: .day, value: 6, to: Date())!: 0.3,
            Calendar.current.date(byAdding: .day, value: 7, to: Date())!: 0.7,
            
            // Day after tomorrow with 80% progress
            Calendar.current.date(byAdding: .day, value: 8, to: Date())!: 0.9
        ]
        let highlightedDays: Set<Int> = [1,2,4,6]
        return (progressDate, highlightedDays)
    }
    
    func fetchWorkouts() {
        let cacheKey = "allWorkouts"
        
        // Check cache
        if let cachedWorkouts = workoutCache[cacheKey] {
            // Use cached data (even if it's nil)
            workouts = cachedWorkouts ?? []
            return
        }
        
        // Check if fetching was already attempted
        if fetchWorkoutsAttempted {
            print("Fetch already attempted for key: \(cacheKey)")
            return
        }
        
        isWorkoutLoading = true
        fetchWorkoutsAttempted = true // Mark fetch as attempted
        
        Task {
            do {
                let fetchedWorkouts = try await workoutUseCase.fetchAllWorkouts()
                
                DispatchQueue.main.async { [weak self] in
                    self?.workouts = fetchedWorkouts
                    self?.workoutCache[cacheKey] = fetchedWorkouts // Cache the fetched data
                    self?.isWorkoutLoading = false
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
        if let cachedPlans = workoutPlanCache[formattedDate], !cachedPlans.isEmpty {
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
                    let plan1 = DailyWorkoutPlan.mock()
                    let plan2 = DailyWorkoutPlan.mock()
//                    self.workoutPlans = fetchedWorkoutPlans
                    self.workoutPlans = [plan1, plan2]
                    self.workoutPlanCache[formattedDate] = fetchedWorkoutPlans
                }
            } catch {
                print("Error fetching workout plans: \(error)")
            }
            
        }
    }
    
    // Fetch the weekly plan for the user
    func fetchWeeklyPlan(forUser userId: UUID, date: Date) {
        let cacheKey = generateCacheKey(forUser: userId, date: date)
        
        if let cachedPlan = weeklyPlanCache[cacheKey] {
            // Use cached data for immediate UI update
            weeklyPlan = cachedPlan
            return
        } else {
            upNextWeekNumber = nil // Optionally handle "no data" states
        }
        
        // Check if fetching was already attempted
        if fetchAttempted.contains(cacheKey) {
            print("Fetch already attempted for key: \(cacheKey)")
            return
        }
        
        isWeeklyPlanLoading = true
        upNextWeekNumber = nil
        fetchAttempted.insert(cacheKey) // Mark fetch as attempted
        
        Task {
            do {
                let fetchedWeeklyPlan = try await workoutUseCase.fetchWeeklyPlan(forUser: userId, date: date)
                
                guard !fetchedWeeklyPlan.isEmpty else {
                    self.fetchWeekToGenerate(forUser: userId)
                    return
                }
                
                DispatchQueue.main.async {
                    if let firstPlan = fetchedWeeklyPlan.first {
                        self.weeklyPlan = firstPlan
                        self.weeklyPlanCache[cacheKey] = firstPlan // Cache the fetched data
                    }
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
    
    private func generateCacheKey(forUser userId: UUID, date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let formattedDate = dateFormatter.string(from: date)
        return "\(userId.uuidString)_\(formattedDate)"
    }
    
    func clearCache() {
        weeklyPlanCache.removeAll()
        fetchAttempted.removeAll()
    }
    
    func fetchWeekToGenerate(forUser userId: UUID) {
        if let weekToGenerate = globalAppEnvObject.weekToGenerate {
            DispatchQueue.main.async {
                self.upNextWeekNumber = weekToGenerate + 1
                self.isWeeklyPlanLoading = false
            }
        }else{
            DispatchQueue.main.async {
                self.isWeeklyPlanLoading = false
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
