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

@Model class WorkoutWeekEntity {
    var week: Int
    var startDate: String
    var endDate: String
    var days: [WorkoutDayEntity]

    init(week: Int, startDate: String, endDate: String, days: [WorkoutDayEntity]) {
        self.week = week
        self.startDate = startDate
        self.endDate = endDate
        self.days = days
    }
}

extension WorkoutWeekEntity {
    func toDomain() -> WorkoutWeek {
        return WorkoutWeek(
            week: week,
            startDate: startDate,
            endDate: endDate,
            days: days.map { $0.toDomain() }
        )
    }
}
