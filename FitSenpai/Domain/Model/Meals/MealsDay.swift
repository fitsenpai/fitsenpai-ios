//
//  MealsDay.swift
//  FitSenpai
//
//  Created by Mark Daquis on 5/5/25.
//

struct MealsDay: DomainProtocol {
    let day: String
    let date: String
    let meals: MealsPlan
    let totalDailyMacros: Macros

    func toEntity() -> MealDayEntity {
        return MealDayEntity(
            day: day,
            date: date,
            meals: meals.toEntity(),
            totalDailyMacros: totalDailyMacros.toEntity()
        )
    }
}
