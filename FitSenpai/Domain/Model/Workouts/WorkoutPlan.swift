//
//  WorkoutPlan.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/28/24.
//

import Foundation
import ObjectMapper

// MARK: - WorkoutPlan Object

class WorkoutPlan {
    var id: String?
    var plan: [PlanDetail]?
    var startDate: String?
}

// MARK: - PlanDetail Object

class PlanDetail {
    var week: String?
    var endDate: String?
    var days: [WorkoutDay]?
}

// MARK: - Routine Object

class Routine: Identifiable {
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
    
    init(id: String = UUID().uuidString, name: String? = nil, muscleGroup: String? = nil, routineCount: String? = nil, duration: String? = nil, instructions: [String]? = nil, repetition: String? = nil, sets: String? = nil, load: String? = nil, gifUrl: String? = nil) {
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
}
