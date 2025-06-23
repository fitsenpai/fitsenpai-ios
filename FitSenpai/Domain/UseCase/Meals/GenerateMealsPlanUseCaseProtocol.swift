//
//  GenerateMealsPlanUseCaseProtocol.swift
//  FitSenpai
//
//  Created by Mark Daquis on 6/23/25.
//

import Foundation
import CoreKit

protocol GenerateMealsPlanUseCaseProtocol {
    func execute() async throws -> [WeekPlan<MealsDay>]
}

final class GenerateMealsPlanUseCase: GenerateMealsPlanUseCaseProtocol {
    // MARK: - Dependencies
    @Inject private var repository: MealsRepositoryProtocol
    
    func execute() async throws -> [WeekPlan<MealsDay>] {
        return try await repository.getMealPlan()
    }
}
