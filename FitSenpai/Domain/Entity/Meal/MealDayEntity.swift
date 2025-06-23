//
//  MealDayEntity.swift
//  FitSenpai
//
//  Created by Mark Daquis on 5/7/25.
//

import SwiftData

@Model class MealDayEntity {
    var day: String
    var date: String
    var meals: MealsPlanEntity
    var totalDailyMacros: MacrosEntity
    var pendingGeneration: Bool
    
    init(day: String, date: String, meals: MealsPlanEntity, totalDailyMacros: MacrosEntity, pendingGeneration: Bool = false) {
        self.day = day
        self.date = date
        self.meals = meals
        self.totalDailyMacros = totalDailyMacros
        self.pendingGeneration = pendingGeneration
    }

    func toDomain() -> MealsDay {
        return MealsDay(
            day: day,
            date: date,
            meals: meals.toDomain(),
            totalDailyMacros: totalDailyMacros.toDomain(),
            pendingGeneration: pendingGeneration
        )
    }
}
