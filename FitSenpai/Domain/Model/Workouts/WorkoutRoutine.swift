//
//  WorkoutRoutine.swift
//  FitSenpai
//
//  Created by Mark Daquis on 6/23/25.
//

import Foundation

class WorkoutRoutine: Identifiable {
    var id: String
    var name: String
    var date: String
    var muscleGroup: String?
    var routineCount: Int?
    var duration: Int?
    var instructions: [String]
    var repetition: Int?
    var sets: Int?
    var load: String?
    var gifUrl: String?
    var sortIndex: Int
    var isCompleted: Bool
    
    init(date: String, name: String, muscleGroup: String? = nil, routineCount: Int? = nil, duration: Int? = nil, instructions: [String]? = nil, repetition: Int? = nil, sets: Int? = nil, load: String? = nil, gifUrl: String? = nil, sortIndex: Int = 0, isCompleted: Bool) {
        self.id = "\(name)-\(date)"
        self.name = name
        self.muscleGroup = muscleGroup
        self.routineCount = routineCount
        self.duration = duration
        self.instructions = instructions ?? []
        self.repetition = repetition
        self.sets = sets
        self.load = load
        self.gifUrl = gifUrl
        self.sortIndex = sortIndex
        self.isCompleted = isCompleted
        self.date = date
    }
    
    func toEntity() -> RoutineEntity {
        return RoutineEntity(
            id: id,
            name: name,
            muscleGroup: muscleGroup,
            routineCount: routineCount,
            duration: duration,
            instructions: instructions,
            repetition: repetition,
            sets: sets,
            load: load,
            gifUrl: gifUrl,
            sortIndex: sortIndex,
            isCompleted: isCompleted,
            date: date
        )
    }
}

extension WorkoutRoutine {
    var timerOnly: Bool {
        sets == nil && repetition == nil
    }

    var videoURL: URL {
        URL(string: self.gifUrl ?? "") ?? URL(fileURLWithPath: "")
    }
    
    var muscleGroups: [String] {
        muscleGroup?.split(separator: ",").compactMap({ String($0).trimmingCharacters(in: .whitespaces) }) ?? []
    }
}
