//
//  RoutineEntity.swift
//  FitSenpai
//
//  Created by Mark Daquis on 5/5/25.
//

import SwiftData

@Model
class RoutineEntity: Identifiable {
    @Attribute(.unique) var id: String
    var week: Int
    var day: String
    var name: String
    var muscleGroup: String?
    var routineCount: String?
    var duration: String?
    var instructions: String?
    var repetition: String?
    var sets: String?
    var load: String?
    var gifUrl: String?
    var sortIndex: Int
    var isCompleted: Bool
    var workoutDay: WorkoutDayEntity?

    init(id: String, week: Int, day: String, name: String, muscleGroup: String? = nil, routineCount: String? = nil, duration: String? = nil, instructions: [String]? = nil, repetition: String? = nil, sets: String? = nil, load: String? = nil, gifUrl: String? = nil, sortIndex: Int = 0, isCompleted: Bool = false, workoutDay: WorkoutDayEntity? = nil) {
        self.id = id
        self.name = name
        self.week = week
        self.day = day
        self.muscleGroup = muscleGroup
        self.routineCount = routineCount
        self.duration = duration
        self.instructions = instructions?.joined(separator: ",")
        self.repetition = repetition
        self.sets = sets
        self.load = load
        self.gifUrl = gifUrl
        self.sortIndex = sortIndex
        self.isCompleted = isCompleted
        self.workoutDay = workoutDay
    }

    func toDomain() -> WorkoutRoutine {
        return WorkoutRoutine(
            week: week,
            day: day,
            name: name,
            muscleGroup: muscleGroup,
            routineCount: routineCount,
            duration: duration,
            instructions: instructions?.split(separator: ",").map(String.init),
            repetition: repetition,
            sets: sets,
            load: load,
            gifUrl: gifUrl,
            sortIndex: sortIndex,
            isCompleted: isCompleted
        )
    }
}
