//
//  WorkoutPlanEntity.swift
//  FitSenpai
//
//  Created by Mark Daquis on 5/7/25.
//

import SwiftData

@Model class WorkoutPlanEntity {
    var id: String
    var weeks: [WorkoutWeekEntity]
    var createdAt: String
    var updatedAt: String
    var userId: String
    var profileId: String?

    init(id: String, weeks: [WorkoutWeekEntity], createdAt: String, updatedAt: String, userId: String, profileId: String?) {
        self.id = id
        self.weeks = weeks
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.userId = userId
        self.profileId = profileId
    }
}

extension WorkoutPlanEntity {
    func toDomain() -> WorkoutPlan {
        return WorkoutPlan(
            id: id,
            weeks: weeks.map { $0.toDomain() },
            createdAt: createdAt,
            updatedAt: updatedAt,
            userId: userId,
            profileId: profileId
        )
    }
}
