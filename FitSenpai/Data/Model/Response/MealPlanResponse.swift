//
//  MealPlanResponse.swift
//  FitSenpai
//
//  Created by Mark Daquis on 5/5/25.
//

import Foundation

struct MealPlanResponse: Decodable {
    let meal: DailyMealPlanDTO
    let grocery: GroceryListDTO
}

struct DailyMealPlanDTO: Decodable {
    let day: String?
    let date: String?
    let meals: MealsDTO?
    let totalDailyMacros: MacrosDTO?

    func toDomain() -> DailyMealPlan {
        return DailyMealPlan(
            day: day ?? "",
            date: date ?? "",
            meals: meals?.toDomain() ?? Mealsplan(
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

struct MealsDTO: Decodable {
    let breakfast: MealDTO?
    let lunch: MealDTO?
    let dinner: MealDTO?
    let snack: MealDTO?
    let postWorkout: MealDTO?
    
    func toDomain() -> Mealsplan {
        return Mealsplan (
            breakfast: breakfast?.toDomain() ?? Meal(name: "", ingredients: [], imageUrl: "", recipe: [], macros: Macros(calories: 0, protein: 0, carbs: 0, fat: 0)),
            lunch: lunch?.toDomain() ?? Meal(name: "", ingredients: [], imageUrl: "", recipe: [], macros: Macros(calories: 0, protein: 0, carbs: 0, fat: 0)),
            dinner: dinner?.toDomain() ?? Meal(name: "", ingredients: [], imageUrl: "", recipe: [], macros: Macros(calories: 0, protein: 0, carbs: 0, fat: 0)),
            snack: snack?.toDomain() ?? Meal(name: "", ingredients: [], imageUrl: "", recipe: [], macros: Macros(calories: 0, protein: 0, carbs: 0, fat: 0)),
            postWorkout: postWorkout?.toDomain() ?? Meal(name: "", ingredients: [], imageUrl: "", recipe: [], macros: Macros(calories: 0, protein: 0, carbs: 0, fat: 0))
        )
    }
}

struct MealDTO: Decodable {
    let name: String?
    let ingredients: [String]?
    let imageUrl: String?
    let recipe: [String]?
    let macros: MacrosDTO?

    func toDomain() -> Meal {
        return Meal(
            name: name ?? "",
            ingredients: ingredients ?? [],
            imageUrl: imageUrl ?? "",
            recipe: recipe ?? [],
            macros: macros?.toDomain() ?? Macros(calories: 0, protein: 0, carbs: 0, fat: 0)
        )
    }
}

struct MacrosDTO: Decodable {
    let calories: Int?
    let protein: Int?
    let carbs: Int?
    let fat: Int?

    func toDomain() -> Macros {
        return Macros(
            calories: calories ?? 0,
            protein: protein ?? 0,
            carbs: carbs ?? 0,
            fat: fat ?? 0
        )
    }
}

struct GroceryListDTO: Decodable {
    let week: String?
    let startDate: String?
    let endDate: String?
    let shopping: [ShoppingCategoryDTO]?
    let totalEstimatedPrice: String?

    func toDomain() -> GroceryPlan {
        return GroceryPlan(
            week: week ?? "",
            startDate: startDate ?? "",
            endDate: endDate ?? "",
            shopping: shopping?.map { $0.toDomain() } ?? [],
            totalEstimatedPrice: totalEstimatedPrice ?? ""
        )
    }
}

struct ShoppingCategoryDTO: Decodable {
    let category: String?
    let items: [GroceryItemDTO]?
    let totalEstimatedPrice: String?

    func toDomain() -> ShoppingCategory {
        return ShoppingCategory(
            category: category ?? "",
            items: items?.map { $0.toDomain() } ?? [],
            totalEstimatedPrice: totalEstimatedPrice ?? ""
        )
    }
}

struct GroceryItemDTO: Decodable {
    let name: String?
    let qty: String?
    let estimatedPrice: String?

    func toDomain() -> GroceryItem {
        return GroceryItem(
            name: name ?? "",
            qty: qty ?? "",
            estimatedPrice: estimatedPrice ?? ""
        )
    }
}

