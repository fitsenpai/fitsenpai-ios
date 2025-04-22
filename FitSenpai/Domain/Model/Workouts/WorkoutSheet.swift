//
//  WorkoutSheet.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/8/25.
//

import Foundation

enum WorkoutSheet: Identifiable {
    case changeWorkout
    
    var id: Int {
        hashValue
    }
}
