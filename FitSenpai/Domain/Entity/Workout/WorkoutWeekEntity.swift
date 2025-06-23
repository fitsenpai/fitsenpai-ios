//
//  WorkoutWeekEntity.swift
//  FitSenpai
//
//  Created by Mark Daquis on 5/12/25.
//

import SwiftData

@Model class WorkoutWeekEntity {
    var startDate: String
    var endDate: String
    @Relationship(deleteRule: .cascade, inverse: \WorkoutDayEntity.workoutWeek)
    var days: [WorkoutDayEntity]

    init(startDate: String, endDate: String, days: [WorkoutDayEntity] = []) {
        self.startDate = startDate
        self.endDate = endDate
        self.days = days
    }
}

extension WorkoutWeekEntity {
    func toDomain() -> WeekPlan<WorkoutDay> {
        return WeekPlan<WorkoutDay>(
            startDate: startDate,
            endDate: endDate,
            days: days.map { $0.toDomain() }
        )
    }
}
