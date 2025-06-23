//
//  DailyMealPlanDTO.swift
//  FitSenpai
//
//  Created by Mark Daquis on 6/23/25.
//

import Foundation

struct DailyMealPlanDTO: Decodable {
    let day: String?
    let date: String?
    let meals: MealsDTO?
    let totalDailyMacros: MacrosDTO?

    func toDomain() -> MealsDay {
        return MealsDay(
            day: day ?? "",
            date: date ?? "",
            meals: meals?.toDomain() ?? MealsPlan(
                breakfast: Meal(name: "", ingredients: [], imageUrl: "", recipe: [], macros: Macros(calories: 0, protein: 0, carbs: 0, fat: 0)),
                lunch: Meal(name: "", ingredients: [], imageUrl: "", recipe: [], macros: Macros(calories: 0, protein: 0, carbs: 0, fat: 0)),
                dinner: Meal(name: "", ingredients: [], imageUrl: "", recipe: [], macros: Macros(calories: 0, protein: 0, carbs: 0, fat: 0)),
                snack: Meal(name: "", ingredients: [], imageUrl: "", recipe: [], macros: Macros(calories: 0, protein: 0, carbs: 0, fat: 0)),
                postWorkout: Meal(name: "", ingredients: [], imageUrl: "", recipe: [], macros: Macros(calories: 0, protein: 0, carbs: 0, fat: 0))
            ),
            totalDailyMacros: totalDailyMacros?.toDomain() ?? Macros(calories: 0, protein: 0, carbs: 0, fat: 0)
        )
    }
}
