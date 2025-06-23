//
//  WorkoutWeek.swift
//  FitSenpai
//
//  Created by Mark Daquis on 5/13/25.
//

class WorkoutWeek {
    var startDate: String
    var endDate: String
    var days: [WorkoutDay]

    init(startDate: String, endDate: String, days: [WorkoutDay]) {
        self.startDate = startDate
        self.endDate = endDate
        self.days = days
    }
}

extension WorkoutWeek {
    func toEntity() -> WorkoutWeekEntity {
        return WorkoutWeekEntity(
            startDate: startDate,
            endDate: endDate,
            days: days.map { $0.toEntity() }
        )
    }
}
