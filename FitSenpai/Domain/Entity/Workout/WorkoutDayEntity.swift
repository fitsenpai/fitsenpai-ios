//
//  WorkoutDayEntity.swift
//  FitSenpai
//
//  Created by Mark Daquis on 5/5/25.
//

import SwiftData

@Model class WorkoutDayEntity {
    var id: String
    @Relationship(deleteRule: .cascade, inverse: \RoutineEntity.workoutDay)
    var routines: [RoutineEntity]
    var totalTime: Int
    var day: String
    var date: String
    var totalRoutines: Int
    var title: String
    var pendingGeneration: Bool
    var workoutWeek: WorkoutWeekEntity?
    
    init(id: String, routines: [RoutineEntity] = [], totalTime: Int, day: String, date: String, totalRoutines: Int, title: String, pendingGeneration: Bool, workoutWeek: WorkoutWeekEntity? = nil) {
        self.id = id
        self.routines = routines
        self.totalTime = totalTime
        self.day = day
        self.date = date
        self.totalRoutines = totalRoutines
        self.title = title
        self.pendingGeneration = pendingGeneration
        self.workoutWeek = workoutWeek
    }
}

extension WorkoutDayEntity {
    func toDomain() -> WorkoutDay {
        return WorkoutDay(
            id: id,
            routines: routines.map({ $0.toDomain() }),
            totalTime: totalTime,
            day: day,
            date: date,
            totalRoutines: totalRoutines,
            title: title,
            pendingGeneration: pendingGeneration
        )
    }
}
