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
    
    @AppState(\.trialStartDate) private var trialStartDate

    func generateMealPlanDemo(_ params: WorkoutDemoRequest) async throws -> ([WeekPlan<MealsDay>], GroceryWeek) {
        let response = try await remoteDataSource.generateMealPlanDemo(params)
    
        let mealsDay = response.meal.toDomain()
        let mealsWeek = WeekPlan<MealsDay>.init(week: 1, startDate: Date().formatted(), endDate: Date().formatted(), days: [mealsDay])
        
        mealsDataStore.deleteAll()
        mealsDataStore.add(mealsWeek.toEntity())
        
        let groceryPlan = response.grocery.toDomain()
        groceriesDataStore.deleteAll()
        groceriesDataStore.add(groceryPlan.toEntity())
        
        return ([mealsWeek], groceryPlan)
    }
    
    func getMealPlan() async throws -> [WeekPlan<MealsDay>] {
        mealsDataStore.items.map({ $0.toDomain() })
    }
    
}
