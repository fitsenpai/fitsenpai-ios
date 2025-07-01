//
//  UpdateRoutineUseCaseProtocol.swift
//  FitSenpai
//
//  Created by Mark Daquis on 5/20/25.
//


import Foundation
import CoreKit

protocol UpdateRoutineUseCaseProtocol {
    func execute(date: String, name: String) async throws
}

final class UpdateRoutineUseCase: UpdateRoutineUseCaseProtocol {
    
    // MARK: - Dependencies
    @Inject private var repository: WorkoutRepositoryProtocol
    
    func execute(date: String, name: String) async throws {
        try await repository.updateRoutine(date: date, name: name)
    }
}
