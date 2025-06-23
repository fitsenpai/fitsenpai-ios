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
    var routineCount: String?
    var duration: String?
    var instructions: [String]
    var repetition: String?
    var sets: String?
    var load: String?
    var gifUrl: String?
    var sortIndex: Int
    var isCompleted: Bool
    
    init(date: String, name: String, muscleGroup: String? = nil, routineCount: String? = nil, duration: String? = nil, instructions: [String]? = nil, repetition: String? = nil, sets: String? = nil, load: String? = nil, gifUrl: String? = nil, sortIndex: Int = 0, isCompleted: Bool) {
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
    var intReps: Int? {
        Int(self.repetition ?? "")
    }
    
    var intSets: Int? {
        Int(self.sets ?? "")
    }
    
    var timerOnly: Bool {
        intSets == nil && intReps == nil
    }

    var intDuration: Int? {
        guard let duration else { return 0 }
        let durationTime = duration.split(separator: " ").compactMap({ String($0).trimmingCharacters(in: .whitespaces) }).first ?? "0"
        return Int(durationTime)
    }
    
    var videoURL: URL {
        URL(string: self.gifUrl ?? "") ?? URL(fileURLWithPath: "")
    }
    
    var muscleGroups: [String] {
        muscleGroup?.split(separator: ",").compactMap({ String($0).trimmingCharacters(in: .whitespaces) }) ?? []
    }
}
