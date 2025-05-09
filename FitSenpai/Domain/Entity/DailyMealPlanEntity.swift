//
//  DailyMealPlanEntity.swift
//  FitSenpai
//
//  Created by Mark Daquis on 5/7/25.
//

import SwiftData

@Model class DailyMealPlanEntity {
    var day: String
    var date: String
    var meals: MealsPlanEntity
    var totalDailyMacros: MacrosEntity
    
    init(day: String, date: String, meals: MealsPlanEntity, totalDailyMacros: MacrosEntity) {
        self.day = day
        self.date = date
        self.meals = meals
        self.totalDailyMacros = totalDailyMacros
    }

    func toDomain() -> DailyMealPlan {
        return DailyMealPlan(
            day: day,
            date: date,
            meals: meals.toDomain(),
            totalDailyMacros: totalDailyMacros.toDomain()
        )
    }
}
