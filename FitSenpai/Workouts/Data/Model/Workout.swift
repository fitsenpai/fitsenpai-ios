//
//  Workout.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/28/24.
//

import Foundation

struct Workout: Decodable, Equatable {
    let id: Int64
    let createdAt: String?
    let exerciseId: Int64
    let exerciseName: String
    let muscleGroup: String
    let displayName: String
    let url: String

    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case exerciseId = "exercise_id"
        case exerciseName = "exercise_name"
        case muscleGroup = "muscle_group"
        case displayName = "display_name"
        case url
    }
}
