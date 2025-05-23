//
//  WeekPlan.swift
//  FitSenpai
//
//  Created by Mark Daquis on 5/13/25.
//

protocol DomainProtocol {
    associatedtype Entity
    func toEntity() -> Entity
}

class WeekPlan<T: DomainProtocol> {
    var week: Int
    var startDate: String
    var endDate: String
    var days: [T]

    init(week: Int, startDate: String, endDate: String, days: [T]) {
        self.week = week
        self.startDate = startDate
        self.endDate = endDate
        self.days = days
    }
}

extension WeekPlan where T.Entity == WorkoutDayEntity {
    func toEntity() -> WorkoutWeekEntity {
        return WorkoutWeekEntity(
            week: week,
            startDate: startDate,
            endDate: endDate,
            days: days.map { $0.toEntity() }
        )
    }
}

extension WeekPlan where T.Entity == MealDayEntity {
    func toEntity() -> MealsWeekEntity {
        return MealsWeekEntity(
            week: week,
            startDate: startDate,
            endDate: endDate,
            days: days.map { $0.toEntity() }
        )
    }
}
