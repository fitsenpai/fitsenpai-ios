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
    let pendingGeneration: Bool?

    enum CodingKeys: String, CodingKey {
        case day
        case date
        case meals
        case totalDailyMacros
        case pendingGeneration
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.day = try container.decodeIfPresent(String.self, forKey: .day)
        self.date = try container.decodeIfPresent(String.self, forKey: .date)
        self.meals = try container.decodeIfPresent(MealsDTO.self, forKey: .meals)
        self.totalDailyMacros = try container.decodeIfPresent(MacrosDTO.self, forKey: .totalDailyMacros)
        self.pendingGeneration = try container.decodeIfPresent(Bool.self, forKey: .pendingGeneration) ?? false
    }

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
            totalDailyMacros: totalDailyMacros?.toDomain() ?? Macros(calories: 0, protein: 0, carbs: 0, fat: 0),
            pendingGeneration: pendingGeneration ?? false
        )
    }
}
