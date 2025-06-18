//
//  UpdateRoutineUseCaseProtocol.swift
//  FitSenpai
//
//  Created by Mark Daquis on 5/20/25.
//


import Foundation
import CoreKit

protocol UpdateRoutineUseCaseProtocol {
    func execute(_ id: String) async throws
}

final class UpdateRoutineUseCase: UpdateRoutineUseCaseProtocol {
    
    // MARK: - Dependencies
    @Inject private var repository: WorkoutRepositoryProtocol
    
    func execute(_ id: String) async throws {
        return try await repository.updateRoutine(id)
    }
}
