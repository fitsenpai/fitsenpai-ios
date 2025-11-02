//
//  RoutineDTO.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/24/25.
//

import Foundation

struct RoutineDTO: Decodable {
    let id: Int?
    let name: String?
    let muscleGroup: String?
    let sets: Int?
    let repetition: Int?
    let load: String?
    let routineCount: Int?
    let duration: Int?
    let gifUrl: String?
    let instructions: [String]?
    let completed: Bool?
    
   
    
    enum CodingKeys: CodingKey {
        case id
        case name
        case muscleGroup
        case sets
        case repetition
        case load
        case routineCount
        case duration
        case gifUrl
        case instructions
        case completed
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        func decodeIntOrString(forKey key: CodingKeys) throws -> Int? {
            if let intValue = try? container.decodeIfPresent(Int.self, forKey: key) {
                return intValue
            } else if let stringValue = try? container.decodeIfPresent(String.self, forKey: key) {
                return Int(stringValue)
            }
            return nil
        }
        
        self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.muscleGroup = try container.decodeIfPresent(String.self, forKey: .muscleGroup)
        self.load = try container.decodeIfPresent(String.self, forKey: .load)
        self.gifUrl = try container.decodeIfPresent(String.self, forKey: .gifUrl)
        self.instructions = try container.decodeIfPresent([String].self, forKey: .instructions)
        self.completed = try container.decodeIfPresent(Bool.self, forKey: .completed)
        self.sets = try decodeIntOrString(forKey: .sets)
        self.repetition = try decodeIntOrString(forKey: .repetition)
        self.duration = try decodeIntOrString(forKey: .duration)
        self.routineCount = try decodeIntOrString(forKey: .routineCount)
    }
    
    func toDomain(date: String) -> WorkoutRoutine {
        .init(date: date, name: name ?? "", muscleGroup: muscleGroup, routineCount: routineCount, duration: duration, instructions: instructions, repetition: repetition, sets: sets, load: load, gifUrl: gifUrl, isCompleted: completed ?? false)
    }
}
