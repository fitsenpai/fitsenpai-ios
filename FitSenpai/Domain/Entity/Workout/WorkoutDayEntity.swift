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
    var totalTime: String
    var day: String
    var totalRoutines: String
    var title: String
    var pendingGeneration: Bool
    var workoutWeek: WorkoutWeekEntity?
    
    init(id: String, routines: [RoutineEntity] = [], totalTime: String, day: String, totalRoutines: String, title: String, pendingGeneration: Bool, workoutWeek: WorkoutWeekEntity? = nil) {
        self.id = id
        self.routines = routines
        self.totalTime = totalTime
        self.day = day
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
            totalRoutines: totalRoutines,
            title: title,
            pendingGeneration: pendingGeneration
        )
    }
    
    func generateUniqueRoutineId(routineName: String) -> String {
        let weekNumber = workoutWeek?.week ?? 0
        return "\(id)_week\(weekNumber)_\(routineName.replacingOccurrences(of: " ", with: "_"))"
    }
}
