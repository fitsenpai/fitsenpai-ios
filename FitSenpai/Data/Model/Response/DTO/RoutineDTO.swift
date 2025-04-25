//
//  RoutineDTO.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/24/25.
//

struct RoutineDTO: Decodable {
    let id: String
    let name: String
    let muscleGroup: String
    let sets: String
    let repetition: String
    let load: String
    let routineCount: String
    let duration: String
    let gifUrl: String
    let instructions: [String]
    
    func toDomain() -> Routine {
        .init(id: id, name: name, muscleGroup: muscleGroup, routineCount: routineCount, duration: duration, instructions: instructions, repetition: repetition, sets: sets, load: load, gifUrl: gifUrl)
    }
}
