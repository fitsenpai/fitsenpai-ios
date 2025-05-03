//
//  FSTabs.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/29/25.
//

import Foundation

enum FSTabs: CaseIterable {
    case workouts
    case meals
    case groceries
    case progress
    
    var title: String {
        switch self {
        case .workouts: return "Workouts"
        case .meals: return "Meals"
        case .groceries: return "Groceries"
        case .progress: return "Progress"
        }
    }
    
    var icon: String {
        switch self {
        case .workouts: return "tab_workout"
        case .meals: return "tab_meals"
        case .groceries: return "tab_groceries"
        case .progress: return "tab_progress"
        }
    }
}
