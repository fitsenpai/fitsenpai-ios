//
//  WorkoutWeek.swift
//  FitSenpai
//
//  Created by Mark Daquis on 5/13/25.
//


class WorkoutWeek {
    var week: Int
    var startDate: String
    var endDate: String
    var days: [WorkoutDay]

    init(week: Int, startDate: String, endDate: String, days: [WorkoutDay]) {
        self.week = week
        self.startDate = startDate
        self.endDate = endDate
        self.days = days
    }
}

extension WorkoutWeek {
    func toEntity() -> WorkoutWeekEntity {
        return WorkoutWeekEntity(
            week: week,
            startDate: startDate,
            endDate: endDate,
            days: days.map { $0.toEntity() }
        )
    }
}
