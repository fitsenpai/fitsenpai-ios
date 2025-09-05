//
//  UpdateRoutineUseCaseProtocol.swift
//  FitSenpai
//
//  Created by Mark Daquis on 5/20/25.
//


import Foundation
import CoreKit

protocol UpdateRoutineUseCaseProtocol {
    func execute(id: String, date: String, name: String) async throws
}

final class UpdateRoutineUseCase: UpdateRoutineUseCaseProtocol {
    
    // MARK: - Dependencies
    @Inject private var repository: WorkoutRepositoryProtocol
    
    func execute(id: String, date: String, name: String) async throws {
        try await repository.updateRoutine(id: id, date: date, name: name)
    }
}
