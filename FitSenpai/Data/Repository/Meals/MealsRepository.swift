//
//  MealstRepository.swift
//  FitSenpai
//
//  Created by Mark Daquis on 5/5/25.
//


import Foundation
import CoreKit

final class MealsRepository: MealsRepositoryProtocol {
  
    // MARK: - Dependencies
    @Inject private var remoteDataSource: MealsDataSourceProtocol
    @Inject private var mealsDataStore: MealsDataStore
    @Inject private var groceriesDataStore: GroceriesDataStore

    func generateMealPlanDemo(_ params: WorkoutDemoRequest) async throws -> (DailyMealPlan, GroceryPlan) {
        let response = try await remoteDataSource.generateMealPlanDemo(params)
        let mealPlan = response.meal.toDomain()
        let groceryPlan = response.grocery.toDomain()
        await mealsDataStore.deleteAll()
        await mealsDataStore.add(mealPlan.toEntity())
        await groceriesDataStore.deleteAll()
        await groceriesDataStore.add(groceryPlan.toEntity())
        
        return (mealPlan, groceryPlan)
    }
    
}
