//
//  MealsDataSource.swift
//  FitSenpai
//
//  Created by Mark Daquis on 5/6/25.
//

import Foundation
import CoreKit

protocol MealsDataSourceProtocol {
    func generateMealPlanDemo(_ params: WorkoutDemoRequest) async throws -> MealPlanResponse
}

final class MealsDataSource: MealsDataSourceProtocol {
    
    // MARK: - Dependencies
    @Inject(key: "meals")
    private var networkService: NetworkService<MealsEndpoint>
    
    // MARK: - API Calls
    
    func generateMealPlanDemo(_ params: WorkoutDemoRequest) async throws -> MealPlanResponse {
        return try await networkService.request(.generateMealsDemo(params))

    }
}
