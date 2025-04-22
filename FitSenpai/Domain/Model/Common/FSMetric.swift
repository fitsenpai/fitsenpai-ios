//
//  FSMetric.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/23/24.
//

import Foundation


enum FSMetric {
    case WorkoutRep, WorkoutSet, WorkoutTime, Calories, KCal, Carbs, Protein, Fat
    
    func getInfoForIcon(_ value: Int) -> (iconName: String, description: String) {
        switch self {
        case .WorkoutRep:
            return (iconName: "icon_repeat_purple", description: "\(value) reps")
        case .WorkoutSet:
            return (iconName: "icon_chart_orange", description: "\(value) sets")
        case .WorkoutTime:
            return (iconName: "icon_clock_green", description: "\(value) mins")
        case .Calories:
            return (iconName: "icon_fire_green", description: "\(value)")
        case .KCal:
            return (iconName: "icon_fire_green", description: "\(value) kcal")
        case .Carbs:
            return (iconName: "icon_bread_blue", description: "\(value)g")
        case .Protein:
            return (iconName: "icon_bone_orange", description: "\(value)g")
        case .Fat:
            return (iconName: "icon_avocado_purple", description: "\(value)g")
        }
    }

}
