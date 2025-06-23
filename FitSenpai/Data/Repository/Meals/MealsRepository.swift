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
        let mealsWeek = WeekPlan<MealsDay>.init(startDate: Date().formatted(), endDate: Date().formatted(), days: [mealsDay])
        
        mealsDataStore.deleteAll()
        mealsDataStore.add(mealsWeek.toEntity())
        
        let groceryPlan = response.grocery.toDomain()
        groceriesDataStore.deleteAll()
        groceriesDataStore.add(groceryPlan.toEntity())
        
        return ([mealsWeek], groceryPlan)
    }
    
    func getMealPlan() async throws -> [WeekPlan<MealsDay>] {
        if trialStartDate != nil {
            return mealsDataStore.items.map({ $0.toDomain() })
        } else {
            let mealPlanResponse = try await remoteDataSource.getMealPlan()
            mealsDataStore.deleteAll()
            let domainPlan = mealPlanResponse.plan.map({ mealplan in
                return WeekPlan<MealsDay>.init(startDate: mealplan.startDate, endDate: mealplan.endDate, days: mealplan.days.map({ $0.toDomain() }))
            })
            mealsDataStore.addBatch(domainPlan.map({ $0.toEntity() }))
            
            return domainPlan
        }
    }
    
    func generateMealPlan(_ params: GenerateRequest) async throws  {
        try await remoteDataSource.generateMealPlan(params)
    }
    
    func regenerateMealPlan(_ params: RegenerateRequest) async throws {
        try await remoteDataSource.regenerateMealPlan(params)
    }
    
}
