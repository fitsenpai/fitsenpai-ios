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
    var startDate: String
    var endDate: String
    var days: [T]

    init(startDate: String, endDate: String, days: [T]) {
        self.startDate = startDate
        self.endDate = endDate
        self.days = days
    }
}

extension WeekPlan where T.Entity == WorkoutDayEntity {
    func toEntity() -> WorkoutWeekEntity {
        return WorkoutWeekEntity(
            startDate: startDate,
            endDate: endDate,
            days: days.map { $0.toEntity() }
        )
    }
}

extension WeekPlan where T.Entity == MealDayEntity {
    func toEntity() -> MealsWeekEntity {
        return MealsWeekEntity(
            startDate: startDate,
            endDate: endDate,
            days: days.map { $0.toEntity() }
        )
    }
}
