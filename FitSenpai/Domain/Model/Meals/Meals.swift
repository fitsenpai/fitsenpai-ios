//
//  Meals.swift
//  FitSenpai
//
//  Created by Mark Daquis on 5/5/25.
//


struct Mealsplan {
    let breakfast: Meal
    let lunch: Meal
    let dinner: Meal
    let snack: Meal
    let postWorkout: Meal

    func toEntity() -> MealsPlanEntity {
        return MealsPlanEntity(
            breakfast: breakfast.toEntity(),
            lunch: lunch.toEntity(),
            dinner: dinner.toEntity(),
            snack: snack.toEntity(),
            postWorkout: postWorkout.toEntity()
        )
    }
}

struct Meal {
    let name: String
    let ingredients: [String]
    let imageUrl: String
    let recipe: [String]
    let macros: Macros

    func toEntity() -> MealEntity {
        return MealEntity(
            name: name,
            ingredients: ingredients,
            imageUrl: imageUrl,
            recipe: recipe,
            macros: macros.toEntity()
        )
    }
}

struct Macros {
    let calories: Int
    let protein: Int
    let carbs: Int
    let fat: Int

    func toEntity() -> MacrosEntity {
        return MacrosEntity(
            calories: calories,
            protein: protein,
            carbs: carbs,
            fat: fat
        )
    }
}
