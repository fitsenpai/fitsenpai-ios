//
//  GenerateRequest.swift
//  FitSenpai
//
//  Created by Mark Daquis on 6/23/25.
//

struct WorkoutProfileRequest: ParameterProtocol {
    let gender: String?
    let genderOther: String?
    let activityLevel: String?
    let previousExperience: [String]?
    let height_cm: Double?
    let weight_kg: Double?
    let birthYear: String?
    let mainGoal: String?
    let fitnessBarrier: String?
    let fitnessGoal: String?
    let workoutExperience: String?
    let workoutLocation: String?
    let workoutDuration: String?
    let healthConcerns: [String]?
    let otherHealthConcern: String?
    let cookingStyle: String?
    let workoutDays: [String]?
    let dietPreference: String?
    let otherDietPreference: String?
    let allergies: [String]?
    let otherAllergies: String?
}

struct GenerateRequest: ParameterProtocol {
    let date: String
}

struct RegenerateRequest: ParameterProtocol {
    let date: String
    let instruction: String
}

struct UpdateRoutineRequest: ParameterProtocol {
    let date: String
    let name: String
}

struct FeedbackRequest: ParameterProtocol {
    let message: String
    let category: String
    let trackingDate: String
    let type: String
    let path: String
}

struct WeightRequest: ParameterProtocol {
    let weight: Double
    let date: String
}
