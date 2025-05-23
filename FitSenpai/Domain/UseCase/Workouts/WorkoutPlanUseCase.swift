//
//  WorkoutPlanUseCaseProtocol.swift
//  FitSenpai
//
//  Created by Mark Daquis on 5/7/25.
//

import Foundation
import CoreKit

protocol WorkoutPlanUseCaseProtocol {
    func execute() async throws -> [WeekPlan<WorkoutDay>]
}

final class WorkoutPlanUseCase: WorkoutPlanUseCaseProtocol {
    // MARK: - Dependencies
    @Inject private var repository: WorkoutRepositoryProtocol
    
    func execute() async throws -> [WeekPlan<WorkoutDay>] {
        return try await repository.getWorkoutPlan()
    }
}
