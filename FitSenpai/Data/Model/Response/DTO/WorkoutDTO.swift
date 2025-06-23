//
//  WorkoutPlanResponse.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/24/25.
//

import Foundation

struct WorkoutWeekDTO: Decodable {
    let startDate: String
    let endDate: String
    let days: [WorkoutDayDTO]
    
    enum CodingKeys: String, CodingKey {
        case week, startDate, endDate, days
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.startDate = try container.decode(String.self, forKey: .startDate)
        self.endDate = try container.decode(String.self, forKey: .endDate)
        self.days = try container.decode([WorkoutDayDTO].self, forKey: .days)
    }

    func toDomain() -> WeekPlan<WorkoutDay> {
        return WeekPlan<WorkoutDay>(
            startDate: startDate,
            endDate: endDate,
            days: days.map { $0.toDomain() }
        )
    }
}

struct WorkoutDayDTO: Decodable {
    var id: String
    let day: String
    let date: String
    let title: String
    let totalTime: String
    let totalRoutines: String
    let routines: [RoutineDTO]
    let pendingGeneration: Bool
    
    enum CodingKeys: CodingKey {
        case id
        case day
        case date
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
        self.date = try container.decodeIfPresent(String.self, forKey: .day) ?? ""
        self.title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
        self.totalTime = try container.decodeIfPresent(String.self, forKey: .totalTime) ?? ""
        self.totalRoutines = try container.decodeIfPresent(String.self, forKey: .totalRoutines) ?? ""
        self.routines = try container.decodeIfPresent([RoutineDTO].self, forKey: .routines) ?? []
        self.pendingGeneration = try container.decodeIfPresent(Bool.self, forKey: .pendingGeneration) ?? false
    }
    
    func toDomain() -> WorkoutDay {
        let routines = routines.enumerated()
            .map({ (index, data) in
                let domain = data.toDomain(date: date)
                domain.sortIndex = index
                return domain
            })
        return .init(id: id, routines: routines, totalTime: totalTime, day: day, date: date, totalRoutines: totalRoutines, title: title, pendingGeneration: pendingGeneration)
    }
}
