//
//  FeedbackType.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/5/25.
//

enum WorkoutSheetType: Identifiable {
    case positive
    case negative
    case negativeInput
    case changeWorkout
    
    
    var id: Int {
        hashValue
    }
}
