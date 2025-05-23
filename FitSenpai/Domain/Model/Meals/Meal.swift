//
//  Meals.swift
//  FitSenpai
//
//  Created by Mark Daquis on 5/5/25.
//

import Foundation

struct Meal: Identifiable {
    let id: String = UUID().uuidString
    let name: String
    let ingredients: [String]
    let imageUrl: String
    let recipe: [String]
    let macros: Macros
    var type: MealType = .breakfast

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
