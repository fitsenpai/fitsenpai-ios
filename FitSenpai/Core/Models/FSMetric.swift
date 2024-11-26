//
//  FSMetric.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/23/24.
//

import Foundation


enum FSMetric {
    case WorkoutRep, WorkoutSet, WorkoutWeight, Calories, Carbs, Protein, Fat
    
    func getInfoForIcon(_ value: Int) -> (iconName: String, description: String) {
        switch self {
        case .WorkoutRep:
            return (iconName: "ic_reps", description: "\(value) reps")
        case .WorkoutSet:
            return (iconName: "ic_sets", description: "\(value) sets")
        case .WorkoutWeight:
            return (iconName: "ic_weight", description: "\(value) kg")
        case .Calories:
            return (iconName: "ic_calorie", description: "\(value)")
        case .Carbs:
            return (iconName: "ic_carbs", description: "\(value)g")
        case .Protein:
            return (iconName: "ic_protein", description: "\(value)g")
        case .Fat:
            return (iconName: "ic_fat", description: "\(value)g")
        }
    }

}
