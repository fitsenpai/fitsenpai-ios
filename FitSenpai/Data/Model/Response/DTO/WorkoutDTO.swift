//
//  WorkoutPlanResponse.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/24/25.
//

import Foundation

struct WorkoutPlanResponse: Decodable {
    let id: String
    let plan: [WorkoutWeekDTO]
    let createdAt: String?
    let updatedAt: String?
    let userId: String?
    let profileId: String?
    
    enum CodingKeys: String, CodingKey {
        case id, plan
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case userId = "user_id"
        case profileId = "profile_id"
    }
}

struct WorkoutWeekDTO: Decodable {
    let week: Int
    let startDate: String
    let endDate: String
    let days: [WorkoutDayDTO]
    
    enum CodingKeys: String, CodingKey {
        case week, startDate, endDate, days
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        if let intWeek = try? container.decode(Int.self, forKey: .week) {
            self.week = intWeek
        } else if let stringWeek = try? container.decode(String.self, forKey: .week), let intFromString = Int(stringWeek) {
            self.week = intFromString
        } else {
            self.week = 0
        }

        self.startDate = try container.decode(String.self, forKey: .startDate)
        self.endDate = try container.decode(String.self, forKey: .endDate)
        self.days = try container.decode([WorkoutDayDTO].self, forKey: .days)
    }

    func toDomain() -> WeekPlan<WorkoutDay> {
        return WeekPlan<WorkoutDay>(
            week: week,
            startDate: startDate,
            endDate: endDate,
            days: days.map { $0.toDomain() }
        )
    }
}

struct WorkoutDayDTO: Decodable {
    var id: String
    let day: String
    let title: String
    let totalTime: String
    let totalRoutines: String
    let routines: [RoutineDTO]
    let pendingGeneration: Bool
    
    enum CodingKeys: CodingKey {
        case id
        case day
        case title
        case totalTime
        case totalRoutines
        case routines
        case pendingGeneration
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(String.self, forKey: .id) ?? UUID().uuidString
        self.day = try container.decodeIfPresent(String.self, forKey: .day) ?? ""
        self.title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
        self.totalTime = try container.decodeIfPresent(String.self, forKey: .totalTime) ?? ""
        self.totalRoutines = try container.decodeIfPresent(String.self, forKey: .totalRoutines) ?? ""
        self.routines = try container.decodeIfPresent([RoutineDTO].self, forKey: .routines) ?? []
        self.pendingGeneration = try container.decodeIfPresent(Bool.self, forKey: .pendingGeneration) ?? false
    }
    
    func toDomain() -> WorkoutDay {
        let routines = routines.enumerated()
            .map({ (index, data) in
                let domain = data.toDomain()
                domain.sortIndex = index
                return domain
            })
        return .init(id: id, routines: routines, totalTime: totalTime, day: day, totalRoutines: totalRoutines, title: title, pendingGeneration: pendingGeneration)
    }
}
