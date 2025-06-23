//
//  WorkoutDay.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/24/25.
//


import Foundation

class WorkoutDay: DomainProtocol {
    var id: String
    var routines: [WorkoutRoutine]
    var totalTime: String
    var day: String
    var date: String
    var totalRoutines: String
    var title: String
    var pendingGeneration: Bool
    
    init(id: String, routines: [WorkoutRoutine], totalTime: String, day: String, date: String, totalRoutines: String, title: String, pendingGeneration: Bool) {
        self.id = id
        self.routines = routines
        self.totalTime = totalTime
        self.day = day
        self.date = date
        self.totalRoutines = totalRoutines
        self.title = title
        self.pendingGeneration = pendingGeneration
    }
    
    func toEntity() -> WorkoutDayEntity {
        return WorkoutDayEntity(
            id: id,
            routines: routines.sorted(by: { $0.sortIndex < $1.sortIndex }).map { $0.toEntity() },
            totalTime: totalTime,
            day: day,
            date: date,
            totalRoutines: totalRoutines,
            title: title,
            pendingGeneration: pendingGeneration
        )
    }
}

