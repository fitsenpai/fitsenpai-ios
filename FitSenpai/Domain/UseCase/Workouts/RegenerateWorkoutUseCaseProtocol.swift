//
//  RegenerateWorkoutUseCase.swift
//  FitSenpai
//
//  Created by Mark Daquis on 6/23/25.
//

import Foundation
import CoreKit

protocol RegenerateWorkoutUseCaseProtocol {
    func execute(date: String, instruction: String) async throws -> WorkoutDay
}

final class RegenerateWorkoutUseCase: RegenerateWorkoutUseCaseProtocol {
    // MARK: - Dependencies
    @Inject private var repository: WorkoutRepositoryProtocol
    
    func execute(date: String, instruction: String) async throws -> WorkoutDay {
        return try await repository.regenerateWorkouts(.init(date: date, instruction: instruction))
    }
}
