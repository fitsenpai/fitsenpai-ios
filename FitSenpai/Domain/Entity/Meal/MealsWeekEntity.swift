//
//  MealWeekEntity.swift
//  FitSenpai
//
//  Created by Mark Daquis on 5/14/25.
//

import SwiftData

@Model class MealsWeekEntity {
    var week: Int
    var startDate: String
    var endDate: String
    var days: [MealDayEntity]

    init(week: Int, startDate: String, endDate: String, days: [MealDayEntity]) {
        self.week = week
        self.startDate = startDate
        self.endDate = endDate
        self.days = days
    }
}

extension MealsWeekEntity {
    func toDomain() -> WeekPlan<MealsDay> {
        return WeekPlan<MealsDay>(
            week: week,
            startDate: startDate,
            endDate: endDate,
            days: days.map { $0.toDomain() }
        )
    }
}
