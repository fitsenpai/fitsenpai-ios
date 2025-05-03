//
//  WorkoutDemoUseCaseProtocol.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/24/25.
//

import Foundation
import CoreKit

protocol WorkoutDemoUseCaseProtocol {
    func execute(_ parameter: WorkoutDemoRequest) async throws -> DailyWorkout
}

final class WorkoutDemoUseCase: WorkoutDemoUseCaseProtocol {
    // MARK: - Dependencies
    @Inject private var repository: WorkoutRepositoryProtocol
    
    func execute(_ parameter: WorkoutDemoRequest) async throws -> DailyWorkout {
        return try await repository.generateWorkoutDemo(parameter)
    }
}
