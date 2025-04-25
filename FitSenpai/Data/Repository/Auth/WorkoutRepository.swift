//
//  WorkoutRepositoryError.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/24/25.
//

import Foundation

final class WorkoutRepository: WorkoutRepositoryProtocol {
    
    // MARK: - Dependencies
    @Inject private var remoteDataSource: WorkoutDataSourceProtocol

    func generateTrialWorkouts(_ params: TrialWorkoutRequest) async throws -> DailyWorkout {
        try await remoteDataSource.generateTrialWorkout(params).toDomain()
    }
}
