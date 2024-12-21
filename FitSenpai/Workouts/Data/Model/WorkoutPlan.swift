//
//  WorkoutPlan.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/28/24.
//

import Foundation
import ObjectMapper

// MARK: - WorkoutPlan Object

class WorkoutPlan: Mappable, Decodable {
    var id: String?
    var plan: [PlanDetail]?
    var startDate: String?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["id"]
        plan <- map["plan"]
        startDate <- map["start_date"]
    }
}

// MARK: - PlanDetail Object

class PlanDetail: Mappable, Decodable {
    var week: String?
    var endDate: String?
    var days: [DayDetail]?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        week <- map["week"]
        endDate <- map["end_date"]
        days <- map["days"]
    }
}

// MARK: - DayDetail Object

class DayDetail: Mappable, Decodable {
    var routines: [Routine]?
    var totalTime: String?
    var day: String?
    var date: String?
    var totalRoutines: String?
    var title: String?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        routines <- map["routines"]
        totalTime <- map["total_time"]
        day <- map["day"]
        date <- map["date"]
        totalRoutines <- map["total_routines"]
        title <- map["title"]
    }
}

// MARK: - Routine Object

class Routine: Mappable, Decodable {
    var id: String?
    var name: String?
    var muscleGroup: String?
    var routineCount: String?
    var duration: String?
    var instructions: [String]?
    var repetition: String?
    var sets: String?
    var load: String?
    var gifUrl: String?
    
    static func initTest() -> Routine {
        let routine = Routine()
        routine.load = "10"
        routine.repetition = "10"
        routine.sets = "3"
        routine.muscleGroup = "chest"
        routine.instructions = ["Stand with feet shoulder-width apart.",
                                "Bend forward slightly while keeping your back straight.",
                                "Hold the stretch for the duration."]
        routine.gifUrl = "https://txvhbjocxiodvtqreskj.supabase.co/storage/v1/object/public/workouts/abdominals/decline_bench_oblique_crunches_bodyweight.mp4?"
        routine.name = "Bench Press"
        return routine
    }
    
    init() {}
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        muscleGroup <- map["muscle_group"]
        routineCount <- map["routine_count"]
        duration <- map["duration"]
        instructions <- map["instructions"]
        repetition <- map["repetition"]
        sets <- map["sets"]
        load <- map["load"]
        gifUrl <- map["gif_url"]
    }
}
