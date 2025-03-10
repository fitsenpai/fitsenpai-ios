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
    init(
        id: UUID = UUID(),
        date: String? = nil,
        name: String? = nil,
        muscleGroup: String? = nil,
        duration: String? = nil,
        instructions: [String]? = nil,
        repetition: Int? = nil,
        sets: Int? = nil,
        load: String? = nil,
        steps: [String]? = nil,
        url: URL? = nil
    ) {
        self.id = id
        self.date = date
        self.name = name
        self.muscleGroup = muscleGroup
        self.duration = duration
        self.instructions = instructions
        self.repetition = repetition
        self.sets = sets
        self.load = load
        self.steps = steps
        self.url = url
    }
    
    static func mock() -> DailyWorkoutPlan {
        
        return DailyWorkoutPlan(
                    date: "2025-02-03",
                    name: "Full Body Workout",
                    muscleGroup: "Full Body",
                    duration: "45 mins",
                    instructions: ["Warm-up", "Squats", "Bench Press", "Deadlifts", "Cool down"],
                    repetition: 12,
                    sets: 3,
                    load: "Moderate",
                    steps: ["Step 1: Warm-up", "Step 2: Perform exercises", "Step 3: Cool down"],
                    url: URL(string: "https://txvhbjocxiodvtqreskj.supabase.co/storage/v1/object/public/workouts/chest/cable_one_arm_lateral_bent_over.mp4?")
                )
    }
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
