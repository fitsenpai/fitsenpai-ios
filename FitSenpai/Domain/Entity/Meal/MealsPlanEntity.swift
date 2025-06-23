//
//  MealsPlanEntity.swift
//  FitSenpai
//
//  Created by Mark Daquis on 5/7/25.
//

import SwiftData

@Model class MealsPlanEntity {
    var breakfast: MealEntity
    var lunch: MealEntity
    var dinner: MealEntity
    var snack: MealEntity
    var postWorkout: MealEntity
    
    init(breakfast: MealEntity, lunch: MealEntity, dinner: MealEntity, snack: MealEntity, postWorkout: MealEntity) {
        self.breakfast = breakfast
        self.lunch = lunch
        self.dinner = dinner
        self.snack = snack
        self.postWorkout = postWorkout
    }

    func toDomain() -> MealsPlan {
        return MealsPlan(
            breakfast: breakfast.toDomain(),
            lunch: lunch.toDomain(),
            dinner: dinner.toDomain(),
            snack: snack.toDomain(),
            postWorkout: postWorkout.toDomain()
        )
    }
}

@Model class MealEntity {
    var name: String
    var ingredients: String
    var imageUrl: String
    var recipe: String
    var macros: MacrosEntity
    
    init(name: String, ingredients: [String], imageUrl: String, recipe: [String], macros: MacrosEntity) {
        self.name = name
        self.ingredients = ingredients.joined(separator: ",")
        self.imageUrl = imageUrl
        self.recipe = recipe.joined(separator: ",")
        self.macros = macros
    }

    func toDomain() -> Meal {
        return Meal(
            name: name,
            ingredients: ingredients.split(separator: ",").map(String.init),
            imageUrl: imageUrl,
            recipe: recipe.split(separator: ",").map(String.init),
            macros: macros.toDomain()
        )
    }
}

@Model class MacrosEntity {
    var calories: Int
    var protein: Int
    var carbs: Int
    var fat: Int
    
    init(calories: Int, protein: Int, carbs: Int, fat: Int) {
        self.calories = calories
        self.protein = protein
        self.carbs = carbs
        self.fat = fat
    }

    func toDomain() -> Macros {
        return Macros(
            calories: calories,
            protein: protein,
            carbs: carbs,
            fat: fat
        )
    }
}
