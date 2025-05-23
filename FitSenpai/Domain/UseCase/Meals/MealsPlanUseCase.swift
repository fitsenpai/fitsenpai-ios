//
//  MealsPlanUseCase.swift
//  FitSenpai
//
//  Created by Mark Daquis on 5/9/25.
//


import Foundation
import CoreKit

protocol MealsPlanUseCaseProtocol {
    func execute() async throws -> [WeekPlan<MealsDay>]
}

final class MealsPlanUseCase: MealsPlanUseCaseProtocol {
    // MARK: - Dependencies
    @Inject private var repository: MealsRepositoryProtocol
    
    func execute() async throws -> [WeekPlan<MealsDay>] {
        return try await repository.getMealPlan()
    }
}
