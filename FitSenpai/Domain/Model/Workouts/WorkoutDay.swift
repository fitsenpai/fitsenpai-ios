//
//  WorkoutDay.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/24/25.
//


import Foundation

class WorkoutDay {
    var id: String
    var routines: [Routine]
    var totalTime: String
    var day: String
    var totalRoutines: String
    var title: String
    
    init(id: String, routines: [Routine], totalTime: String, day: String, totalRoutines: String, title: String) {
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
            routines: routines.map { $0.toEntity() },
            totalTime: totalTime,
            day: day,
            totalRoutines: totalRoutines,
            title: title
        )
    }
}

class Routine: Identifiable {
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
    var isCompleted: Bool = false
    
    init(id: String = UUID().uuidString, name: String? = nil, muscleGroup: String? = nil, routineCount: String? = nil, duration: String? = nil, instructions: [String]? = nil, repetition: String? = nil, sets: String? = nil, load: String? = nil, gifUrl: String? = nil) {
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
            gifUrl: gifUrl
        )
    }
}

extension Routine {
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
