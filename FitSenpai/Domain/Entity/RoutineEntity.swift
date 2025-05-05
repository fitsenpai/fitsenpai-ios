//
//  RoutineEntity.swift
//  FitSenpai
//
//  Created by Mark Daquis on 5/5/25.
//

import SwiftData

@Model
class RoutineEntity: Identifiable {
    var id: String
    var name: String?
    var muscleGroup: String?
    var routineCount: String?
    var duration: String?
    var instructions: [String]?
    var repetition: String?
    var sets: String?
    var load: String?
    var gifUrl: String?
    
    init(id: String, name: String? = nil, muscleGroup: String? = nil, routineCount: String? = nil, duration: String? = nil, instructions: [String]? = nil, repetition: String? = nil, sets: String? = nil, load: String? = nil, gifUrl: String? = nil) {
        self.id = id
        self.name = name
        self.muscleGroup = muscleGroup
        self.routineCount = routineCount
        self.duration = duration
        self.instructions = instructions
        self.repetition = repetition
        self.sets = sets
        self.load = load
        self.gifUrl = gifUrl
    }
    
    func toDomain() -> Routine {
        return Routine(
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
