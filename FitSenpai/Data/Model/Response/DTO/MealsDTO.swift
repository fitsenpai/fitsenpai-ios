//
//  MealsDTO.swift
//  FitSenpai
//
//  Created by Mark Daquis on 6/23/25.
//

import Foundation

struct MealsDTO: Decodable {
    let breakfast: MealDTO?
    let lunch: MealDTO?
    let dinner: MealDTO?
    let snack: MealDTO?
    let postWorkout: MealDTO?
    
    func toDomain() -> MealsPlan {
        return MealsPlan (
            breakfast: breakfast?.toDomain() ?? Meal(name: "", ingredients: [], imageUrl: "", recipe: [], macros: Macros(calories: 0, protein: 0, carbs: 0, fat: 0)),
            lunch: lunch?.toDomain() ?? Meal(name: "", ingredients: [], imageUrl: "", recipe: [], macros: Macros(calories: 0, protein: 0, carbs: 0, fat: 0)),
            dinner: dinner?.toDomain() ?? Meal(name: "", ingredients: [], imageUrl: "", recipe: [], macros: Macros(calories: 0, protein: 0, carbs: 0, fat: 0)),
            snack: snack?.toDomain() ?? Meal(name: "", ingredients: [], imageUrl: "", recipe: [], macros: Macros(calories: 0, protein: 0, carbs: 0, fat: 0)),
            postWorkout: postWorkout?.toDomain() ?? Meal(name: "", ingredients: [], imageUrl: "", recipe: [], macros: Macros(calories: 0, protein: 0, carbs: 0, fat: 0))
        )
    }
}
