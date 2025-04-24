//
//  MainViewSheet.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/8/25.
//

import Foundation

enum MainViewSheet: Identifiable {
    case subscription
    case limitedOffer
    
    var id: Int {
        hashValue
    }
}

enum MainTab {
    case workouts, meals, groceries, progress
}
