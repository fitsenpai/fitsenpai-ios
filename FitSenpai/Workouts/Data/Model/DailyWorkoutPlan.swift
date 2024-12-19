//
//  DailyWorkoutPlan.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 12/18/24.
//

import Foundation
import ObjectMapper

struct DailyWorkoutPlan: Mappable, Identifiable, Decodable, Equatable {
    var id: UUID = UUID()
//    var userId: UUID = UUID()
    var date: String? = ""
//    var dailyPlanId: UUID = UUID()
    var name: String? = ""
    var muscleGroup: String? = ""
    var duration: String? = ""
    var instructions: [String]? = []
    var repetition: Int?
    var sets: Int?
    var load: String?
//    var createdAt: Date = Date()
    var steps: [String]?
    var url: URL?
    
    // Default initializer for Mappable
    init?(map: Map) {}
    
    // Manual initializer if needed
    init() {}
    
    // Mapping function for ObjectMapper
    mutating func mapping(map: Map) {
        id            <- (map["id"], UUIDTransform())
//        userId        <- (map["user_id"], UUIDTransform())
        date          <- map["date"]
//        dailyPlanId   <- (map["daily_plan_id"], UUIDTransform())
        name          <- map["name"]
        muscleGroup   <- map["muscle_group"]
        duration      <- map["duration"]
        instructions  <- map["instructions"]
        repetition    <- map["repetition"]
        sets          <- map["sets"]
        load          <- map["load"]
//        createdAt     <- (map["created_at"], DateTransform())
        steps         <- map["steps"]
        url           <- (map["url"], URLTransform())
    }
}
