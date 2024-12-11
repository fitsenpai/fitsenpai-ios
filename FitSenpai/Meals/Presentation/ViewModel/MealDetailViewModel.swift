//
//  MealDetailViewModel.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 12/11/24.
//

import Foundation

class MealDetailViewModel: ObservableObject {
    
    @Published var schedule: String
    @Published var calories: Int
    @Published var fat: Int
    @Published var carbs: Int
    @Published var protein: Int
    @Published var url: URL?
    @Published var ingredients: [String]
    @Published var recipe: [String]
//    @Published var workoutSteps: [String]
    
    init(){
        self.schedule = "Breakfast"
        self.calories = 350
        self.fat = 10
        self.carbs = 40
        self.protein = 10
        self.url = URL(string: "https://placehold.co/600x400/png")
        self.ingredients = ["1/2 cup cottage cheese or Greek yogurt",
                            "1 scoop protein powder (any flavor)",
                            "1/4 cup almond milk (or any milk of choice)",
                            "1/2 teaspoon baking powder",
                            "1/2 teaspoon vanilla extract (optional)",
                            "Sweetener to taste (e.g., honey, stevia)",
                            "1/2 cup rolled oats"]
        self.recipe = ["Blend all ingredients in a blender until smooth.",
                       "Heat a non-stick skillet over medium heat and lightly coat with cooking spray.",
                       "Pour batter onto the skillet to form pancakes of desired size.",
                       "Cook until bubbles form on the surface and edges look set, then flip and cook for another 1-2 minutes.",
                       "Serve with your favorite toppings.",]
    }
}
