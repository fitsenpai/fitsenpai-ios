//
//  MealsPlan.swift
//  FitSenpai
//
//  Created by Mark Daquis on 5/14/25.
//


struct MealsPlan {
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
