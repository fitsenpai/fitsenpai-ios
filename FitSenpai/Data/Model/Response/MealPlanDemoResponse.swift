//
//  MealPlanDemoResponse.swift
//  FitSenpai
//
//  Created by Mark Daquis on 6/23/25.
//

import Foundation

struct MealPlanDemoResponse: Decodable {
    let meal: DailyMealPlanDTO
    let grocery: GroceryWeekDTO
}
