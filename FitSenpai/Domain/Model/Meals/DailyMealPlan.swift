//
//  DailyMealPlan.swift
//  FitSenpai
//
//  Created by Mark Daquis on 5/5/25.
//

struct DailyMealPlan {
    let day: String
    let date: String
    let meals: Mealsplan
    let totalDailyMacros: Macros

    func toEntity() -> DailyMealPlanEntity {
        return DailyMealPlanEntity(
            day: day,
            date: date,
            meals: meals.toEntity(),
            totalDailyMacros: totalDailyMacros.toEntity()
        )
    }
}
