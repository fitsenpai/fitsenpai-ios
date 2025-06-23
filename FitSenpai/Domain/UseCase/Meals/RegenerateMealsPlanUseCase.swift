//
//  RegenerateMealsPlanUseCaseProtocol.swift
//  FitSenpai
//
//  Created by Mark Daquis on 6/24/25.
//


import Foundation
import CoreKit

protocol RegenerateMealsPlanUseCaseProtocol {
    func execute(date: String, instruction: String) async throws
}

final class RegenerateMealsPlanUseCase: RegenerateMealsPlanUseCaseProtocol {
    // MARK: - Dependencies
    @Inject private var repository: MealsRepositoryProtocol
    
    func execute(date: String, instruction: String) async throws {
        try await repository.regenerateMealPlan(.init(date: date, instruction: instruction))
    }
}
