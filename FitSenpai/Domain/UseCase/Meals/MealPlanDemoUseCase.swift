//
//  MealPlanDemoUseCase.swift
//  FitSenpai
//
//  Created by Mark Daquis on 5/6/25.
//


import Foundation
import CoreKit

protocol MealPlanDemoUseCaseProtocol {
    func execute(_ parameter: WorkoutDemoRequest) async throws -> ([WeekPlan<MealsDay>], GroceryWeek)
}

final class MealPlanDemoUseCase: MealPlanDemoUseCaseProtocol {
    // MARK: - Dependencies
    @Inject private var repository: MealsRepositoryProtocol
    
    func execute(_ parameter: WorkoutDemoRequest) async throws -> ([WeekPlan<MealsDay>], GroceryWeek) {
        return try await repository.generateMealPlanDemo(parameter)
    }
}
