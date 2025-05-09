//
//  MealsRepositoryProtocol.swift
//  FitSenpai
//
//  Created by Mark Daquis on 5/5/25.
//


import Foundation

protocol MealsRepositoryProtocol {
    func generateMealPlanDemo(_ params: WorkoutDemoRequest) async throws -> (DailyMealPlan, GroceryPlan)
}
