//
//  MealDetailViewModel.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 12/11/24.
//

import Foundation

class MealDetailViewModel: ObservableObject {
    
    @Published var meal: Meal
    
    init(meal: Meal){
        self.meal = meal
    }
}
