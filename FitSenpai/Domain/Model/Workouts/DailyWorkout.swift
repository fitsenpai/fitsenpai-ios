//
//  DayDetail.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/24/25.
//


import Foundation
import ObjectMapper

class DailyWorkout {
    var routines: [Routine]
    var totalTime: String
    var day: String
    var totalRoutines: String
    var title: String
    
    init(routines: [Routine], totalTime: String, day: String,totalRoutines: String, title: String) {
        self.routines = routines
        self.totalTime = totalTime
        self.day = day
        self.totalRoutines = totalRoutines
        self.title = title
    }
}
