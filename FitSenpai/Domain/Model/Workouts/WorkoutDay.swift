//
//  WorkoutDay.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/24/25.
//


import Foundation

class WorkoutDay: DomainProtocol {
    var id: String
    var routines: [WorkoutRoutine]
    var totalTime: String
    var day: String
    var totalRoutines: String
    var title: String
    
    init(id: String, routines: [WorkoutRoutine], totalTime: String, day: String, totalRoutines: String, title: String) {
        self.id = id
        self.routines = routines
        self.totalTime = totalTime
        self.day = day
        self.totalRoutines = totalRoutines
        self.title = title
    }
    
    func toEntity() -> WorkoutDayEntity {
        return WorkoutDayEntity(
            id: id,
            routines: routines.sorted(by: { $0.sortIndex < $1.sortIndex }).map { $0.toEntity() },
            totalTime: totalTime,
            day: day,
            totalRoutines: totalRoutines,
            title: title
        )
    }
}

class WorkoutRoutine: Identifiable {
    var id: String
    var name: String
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
    
    init(id: String = UUID().uuidString, name: String? = nil, muscleGroup: String? = nil, routineCount: String? = nil, duration: String? = nil, instructions: [String]? = nil, repetition: String? = nil, sets: String? = nil, load: String? = nil, gifUrl: String? = nil, sortIndex: Int = 0, isCompleted: Bool) {
        self.id = id
        self.name = name ?? ""
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
            isCompleted: isCompleted
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
