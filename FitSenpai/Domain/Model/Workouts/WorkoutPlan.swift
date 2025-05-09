//
//  WorkoutPlan.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/28/24.
//

import Foundation
import ObjectMapper

// MARK: - WorkoutPlan Object

class WorkoutPlan {
    var id: String
    var weeks: [WorkoutWeek]
    var createdAt: String
    var updatedAt: String
    var userId: String
    var profileId: String?

    init(id: String, weeks: [WorkoutWeek], createdAt: String, updatedAt: String, userId: String, profileId: String?) {
        self.id = id
        self.weeks = weeks
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.userId = userId
        self.profileId = profileId
    }
}

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

extension WorkoutPlan {
    func toEntity() -> WorkoutPlanEntity {
        return WorkoutPlanEntity(
            id: id,
            weeks: weeks.map { $0.toEntity() },
            createdAt: createdAt,
            updatedAt: updatedAt,
            userId: userId,
            profileId: profileId
        )
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
