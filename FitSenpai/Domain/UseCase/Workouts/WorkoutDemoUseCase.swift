//
//  WorkoutDemoUseCaseProtocol.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/24/25.
//

import Foundation
import CoreKit

protocol WorkoutDemoUseCaseProtocol {
    func execute(_ parameter: WorkoutProfileRequest) async throws -> [WeekPlan<WorkoutDay>]
}

final class WorkoutDemoUseCase: WorkoutDemoUseCaseProtocol {
    // MARK: - Dependencies
    @Inject private var repository: WorkoutRepositoryProtocol
    
    func execute(_ parameter: WorkoutProfileRequest) async throws -> [WeekPlan<WorkoutDay>] {
        return try await repository.generateWorkoutDemo(parameter)
    }
}
