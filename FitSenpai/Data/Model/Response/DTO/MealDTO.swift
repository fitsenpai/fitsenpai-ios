//
//  MealDTO.swift
//  FitSenpai
//
//  Created by Mark Daquis on 6/23/25.
//

import Foundation

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
