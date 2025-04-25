//
//  GenerateTrialWorkoutUseCaseProtocol.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/24/25.
//

import Foundation

protocol TrialWorkoutUseCaseProtocol {
    func execute(_ parameter: TrialWorkoutRequest) async throws -> DailyWorkout
}

final class TrialWorkoutUseCase: TrialWorkoutUseCaseProtocol {
    // MARK: - Dependencies
    @Inject private var repository: WorkoutRepositoryProtocol
    
    func execute(_ parameter: TrialWorkoutRequest) async throws -> DailyWorkout {
        return try await repository.generateTrialWorkouts(parameter)
    }
}
