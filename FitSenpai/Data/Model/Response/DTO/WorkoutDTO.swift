//
//  GeneratedWorkoutDTO.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/24/25.
//


import Foundation

struct WorkoutDTO: Decodable {
    var id: String
    let day: String
    let title: String
    let totalTime: String
    let totalRoutines: String
    let routines: [RoutineDTO]
    
    enum CodingKeys: CodingKey {
        case id
        case day
        case title
        case totalTime
        case totalRoutines
        case routines
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(String.self, forKey: .id) ?? UUID().uuidString
        self.day = try container.decodeIfPresent(String.self, forKey: .day) ?? ""
        self.title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
        self.totalTime = try container.decodeIfPresent(String.self, forKey: .totalTime) ?? ""
        self.totalRoutines = try container.decodeIfPresent(String.self, forKey: .totalRoutines) ?? ""
        self.routines = try container.decodeIfPresent([RoutineDTO].self, forKey: .routines) ?? []
    }
    
    func toDomain() -> DailyWorkout {
        .init(id: id, routines: routines.map({ $0.toDomain() }), totalTime: totalTime, day: day, totalRoutines: totalRoutines, title: title)
    }
}
