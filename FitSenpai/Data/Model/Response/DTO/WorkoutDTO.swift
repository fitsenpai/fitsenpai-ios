//
//  GeneratedWorkoutDTO.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/24/25.
//


import Foundation

struct WorkoutPlanDTO: Decodable {
    let id: String
    let plan: [WorkoutWeekDTO]
    let createdAt: String
    let updatedAt: String
    let userId: String
    let profileId: String?

    enum CodingKeys: String, CodingKey {
        case id, plan
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case userId = "user_id"
        case profileId = "profile_id"
    }
    
    func toDomain() -> WorkoutPlan {
        return WorkoutPlan(id: id, weeks: plan.map { $0.toDomain() }, createdAt: createdAt, updatedAt: updatedAt, userId: userId, profileId: profileId)
    }
}

struct WorkoutWeekDTO: Decodable {
    let week: Int
    let startDate: String
    let endDate: String
    let days: [WorkoutDayDTO]
    
    func toDomain() -> WorkoutWeek {
        return WorkoutWeek(week: week, startDate: startDate, endDate: endDate, days: days.map { $0.toDomain() })
    }
}

struct WorkoutDayDTO: Decodable {
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
    
    func toDomain() -> WorkoutDay {
        .init(id: id, routines: routines.map({ $0.toDomain() }), totalTime: totalTime, day: day, totalRoutines: totalRoutines, title: title)
    }
}
