//
//  GenerateWorkoutUseCase.swift
//  FitSenpai
//
//  Created by Mark Daquis on 5/7/25.
//

import Foundation
import CoreKit

protocol GenerateWorkoutUseCaseProtocol {
    func execute(date: String) async throws -> WeekPlan<WorkoutDay>
}

final class GenerateWorkoutUseCase: GenerateWorkoutUseCaseProtocol {
    // MARK: - Dependencies
    @Inject private var repository: WorkoutRepositoryProtocol
    
    func execute(date: String) async throws -> WeekPlan<WorkoutDay> {
        return try await repository.generateWorkouts(.init(date: date))
    }
}
