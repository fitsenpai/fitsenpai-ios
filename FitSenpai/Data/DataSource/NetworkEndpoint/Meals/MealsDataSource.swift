//
//  MealsDataSource.swift
//  FitSenpai
//
//  Created by Mark Daquis on 5/6/25.
//

import Foundation
import CoreKit

protocol MealsDataSourceProtocol {
    func generateMealPlan(_ params: GenerateRequest) async throws -> Void
    func regenerateMealPlan(_ params: RegenerateRequest) async throws -> Void
    func generateMealPlanDemo(_ params: WorkoutProfileRequest) async throws -> MealPlanDemoResponse
    func getMealPlan() async throws -> MealPlanResponse?
}

final class MealsDataSource: MealsDataSourceProtocol {
   
    // MARK: - Dependencies
    @Inject(key: "meals")
    private var networkService: NetworkService<MealsEndpoint>
    
    // MARK: - API Calls
    
    func generateMealPlanDemo(_ params: WorkoutProfileRequest) async throws -> MealPlanDemoResponse {
        return try await networkService.request(.generateMealsDemo(params))
    }
    
    func getMealPlan() async throws -> MealPlanResponse? {
        return try await networkService.request(.getMealPlan)
    }
    
    func generateMealPlan(_ params: GenerateRequest) async throws {
        return try await networkService.request(.generateMealPlan(params))
    }
    
    func regenerateMealPlan(_ params: RegenerateRequest) async throws {
        return try await networkService.request(.regenerateMealPlan(params))
    }

}
