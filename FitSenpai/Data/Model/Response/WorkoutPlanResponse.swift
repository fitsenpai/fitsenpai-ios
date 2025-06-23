//
//  WorkoutPlanResponse.swift
//  FitSenpai
//
//  Created by Mark Daquis on 6/18/25.
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