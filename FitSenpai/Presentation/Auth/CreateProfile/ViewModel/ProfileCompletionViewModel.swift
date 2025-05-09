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
    
    @Published var progress: Double = 0
    
    @Published var loadingConfiguration: FSLoadingConfig = GenerateLoadingState.generatingWorkout.loadingConfig
    
    func createLimitedWorkoutPlan(profile: UserProfile) async throws {
        showLoading = true
        progress = 0.25
        defer {
            showLoading = false
            progress = 0
        }
        
        FSLogger.debug(profile)

        do {
            async let workout: () = createWorkoutPlan(profile: profile)
            async let meal: () = createMealPlan(profile: profile)

            try await workout
            await MainActor.run { self.progress += 0.25 }

            try await meal
            await MainActor.run { self.progress += 0.25 }

            try await self.createGroceryList(profile: profile)
            await MainActor.run { self.progress += 0.20 }

            let _ = try await saveUserProfileUseCase.execute(profile)
        } catch {
            print("Failed to create full limited plan: \(error)")
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
