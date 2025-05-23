//
//  WorkoutDayEntity.swift
//  FitSenpai
//
//  Created by Mark Daquis on 5/5/25.
//

import SwiftData

@Model class WorkoutDayEntity {
    var id: String
    var routines: [RoutineEntity]
    var totalTime: String
    var day: String
    var totalRoutines: String
    var title: String
    
    init(id: String, routines: [RoutineEntity], totalTime: String, day: String, totalRoutines: String, title: String) {
        self.id = id
        self.routines = routines
        self.totalTime = totalTime
        self.day = day
        self.totalRoutines = totalRoutines
        self.title = title
    }
}

extension WorkoutDayEntity {
    func toDomain() -> WorkoutDay {
        return WorkoutDay(
            id: id,
            routines: routines.map({ $0.toDomain() }),
            totalTime: totalTime,
            day: day,
            totalRoutines: totalRoutines,
            title: title
        )
    }
}

