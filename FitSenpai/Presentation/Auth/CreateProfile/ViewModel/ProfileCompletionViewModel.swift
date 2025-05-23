//
//  ProfileCompletionViewModel.swift
//  FitSenpai
//
//  Created by Mark Daquis on 5/5/25.
//

import Foundation
import CoreKit

@MainActor
class ProfileCompletionViewModel: ObservableObject {
    
    // MARK: - UseCases

    @Inject private var saveUserProfileUseCase: SaveUserProfileUseCaseProtocol
    @Inject private var workoutDemoUseCase: WorkoutDemoUseCaseProtocol
    @Inject private var mealPlanDemoUseCase: MealPlanDemoUseCaseProtocol
    
    @Published var showLoading = false
    
    // @Published var progress: Double = 0 // We'll use this for overall progress bar, not for message switching
    @Published var overallProgress: Double = 0.0
    
    @Published var loadingConfiguration: FSLoadingConfig = GenerateLoadingState.generatingWorkout.loadingConfig
    
    func createLimitedWorkoutPlan(profile: UserProfile) async throws {
        showLoading = true
        // overallProgress = 0 // Initial progress
        // loadingConfiguration will be set sequentially
        
        defer {
            showLoading = false
            // overallProgress = 0 // Reset progress if needed, or let it stay at 1.0
        }
        
        FSLogger.debug(profile)

        do {
            // Step 1: Generating Workout (Display)
            await MainActor.run {
                self.loadingConfiguration = GenerateLoadingState.generatingWorkout.loadingConfig
                self.overallProgress = 0.1 // Small initial progress
            }
            
            // Start tasks concurrently
            async let workoutTaskResult: () = createWorkoutPlan(profile: profile)
            async let mealTaskResult: () = createMealPlan(profile: profile)

            // Wait for workout plan to complete for display sequencing
            try await workoutTaskResult
            await MainActor.run { self.overallProgress = 0.33 } // Update progress after workout

            // Step 2: Generating Meals (Display)
            await MainActor.run {
                self.loadingConfiguration = GenerateLoadingState.generatingMeals.loadingConfig
            }
            // Wait for meal plan to complete
            try await mealTaskResult
            await MainActor.run { self.overallProgress = 0.66 } // Update progress after meal

            // Step 3: Generating Groceries (Display)
            await MainActor.run {
                self.loadingConfiguration = GenerateLoadingState.generatingGroceries.loadingConfig
            }
            try await self.createGroceryList(profile: profile) // This is sequential
            await MainActor.run { self.overallProgress = 0.9 } // Update progress after groceries

            // Step 4: Final Save (can be silent or have its own brief message if desired)
            // If you want a message for this:
            // await MainActor.run {
            //     self.loadingConfiguration = FSLoadingConfig(title: "Finalizing Profile", subtitle: "Saving your preferences...")
            // }
            let _ = try await saveUserProfileUseCase.execute(profile)
            await MainActor.run { self.overallProgress = 1.0 } // Final progress

        } catch {
            FSLogger.error("Failed to create full limited plan: \(error)") // Changed print to FSLogger.error
            // Optionally, set an error state for loadingConfiguration
            // await MainActor.run {
            //     self.loadingConfiguration = FSLoadingConfig(title: "Error", subtitle: "Failed to set up your plan. Please try again.")
            //     // You might want a way for the user to dismiss this or retry from the view
            // }
            throw error
        }
    }
    
    
    func createWorkoutPlan(profile: UserProfile) async throws {
        let _ = try await self.workoutDemoUseCase.execute(profile.toRequestBody())
    }
    
    func createMealPlan(profile: UserProfile) async throws {
        let _ = try await self.mealPlanDemoUseCase.execute(profile.toRequestBody())
    }
    
    func createGroceryList(profile: UserProfile?) async throws {
        try await Task.sleep(for: .seconds(1))
    }
}
