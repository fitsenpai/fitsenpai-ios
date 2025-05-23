//
//  FSMealPeMealTyperiod.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/24/24.
//

import Foundation


enum MealType {
    case breakfast, lunch, dinner, snack, postWorkout
    
    var name: String {
        switch self {
        case .postWorkout:
            return "Post Workout"
        default:
            return String(describing: self).capitalized
        }
    }
    
}
