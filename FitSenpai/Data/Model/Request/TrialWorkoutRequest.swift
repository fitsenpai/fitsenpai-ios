//
//  TrialWorkoutRequest.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/24/25.
//


struct TrialWorkoutRequest: Encodable {
    let sex: String?
    let age: Int?
    let height: Double?
    let heightType: String?
    let weight: Double?
    let weightType: String?
    let hasEquipment: Bool?
    let fitnessGoals: [String]?
    let difficultyLevel: String?
    let workoutAdditionalNotes: String?
    let workoutDuration: String?

    enum CodingKeys: String, CodingKey {
        case sex
        case age
        case height
        case heightType = "height_type"
        case weight
        case weightType = "weight_type"
        case hasEquipment = "has_equipment"
        case fitnessGoals = "fitness_goals"
        case difficultyLevel = "difficulty_level"
        case workoutAdditionalNotes = "workout_additional_notes"
        case workoutDuration = "workout_duration"
    }
}
