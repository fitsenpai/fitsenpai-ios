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
    /// Use case for fetching the current user from a data source (e.g., Supabase).
    @Inject private var saveUserProfileUseCase: SaveUserProfileUseCaseProtocol
    
    /// Auth repository for handling authentication logic
    @Inject private var workoutDemoUseCase: WorkoutDemoUseCaseProtocol
    
    @Published var showLoading = false
    
    /// Configuration for displaying loading indicators throughout the app.
    @Published var progress: Double = 0
    
    @Published var loadingConfiguration: FSLoadingConfig = GenerateLoadingState.generatingWorkout.loadingConfig
    

    func createLimitedWorkoutPlan(profile: UserProfile) async throws {
        showLoading.toggle()
        await withThrowingTaskGroup(of: Void.self) { group in
            group.addTask {
                try await self.createWorkoutPlan(profile: profile)
                await MainActor.run { self.progress += 0.33 }
            }
            group.addTask {
                try await self.createMealPlan(profile: profile)
                await MainActor.run { self.progress += 0.33 }
            }
        }
        
        try await self.createGroceryList(profile: profile)
        await MainActor.run { progress += 0.33 }
    }
    
    
    func createWorkoutPlan(profile: UserProfile) async throws {
        let _ = try await self.workoutDemoUseCase.execute(profile.toRequestBody())
        let _ = try await saveUserProfileUseCase.execute(profile)
    }
    
    func createMealPlan(profile: UserProfile?) async throws {
        try await Task.sleep(for: .seconds(5))
    }
    
    func createGroceryList(profile: UserProfile?) async throws {
        try await Task.sleep(for: .seconds(1))
    }
}
