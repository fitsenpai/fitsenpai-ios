//
//  WeeklyPlan.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 12/18/24.
//

import ObjectMapper
import Foundation

struct WeeklyPlan: Mappable {
    var userId: String?
    var weeklyPlanId: String?
    var weekNumber: Int?
    var startDate: String?
    var endDate: String?
    
    // Default initializer required by Mappable
    init?(map: Map) { }
    
    // Mapping function to map JSON to object properties
    mutating func mapping(map: Map) {
        userId              <- map["user_id"]
        weeklyPlanId <- map["weekly_plan_id"]
        weekNumber     <- map["week_number"]
        startDate      <- map["start_date"]
        endDate        <- map["end_date"]
    }
}
