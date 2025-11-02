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
    var name: String
    var date: String
    var muscleGroup: String?
    var routineCount: Int?
    var duration: Int?
    var instructions: String?
    var repetition: Int?
    var sets: Int?
    var load: String?
    var gifUrl: String?
    var sortIndex: Int
    var isCompleted: Bool
    var workoutDay: WorkoutDayEntity?

    init(id: String, name: String, muscleGroup: String? = nil, routineCount: Int? = nil, duration: Int? = nil, instructions: [String]? = nil, repetition: Int? = nil, sets: Int? = nil, load: String? = nil, gifUrl: String? = nil, sortIndex: Int = 0, isCompleted: Bool = false, workoutDay: WorkoutDayEntity? = nil, date: String) {
        self.id = id
        self.name = name
        self.date = date
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
            date: date,
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
