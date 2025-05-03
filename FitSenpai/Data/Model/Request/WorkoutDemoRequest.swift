//
//  WorkoutDemoRequest.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/24/25.
//


struct WorkoutDemoRequest: ParameterProtocol {
    let gender: String?
    let genderOther: String?
    let activityLevel: String?
    let previousExperience: [String]?
    let height: Double?
    let weight: Double?
    let systemOfMeasurement: String?
    let birthYear: String?
    let mainGoal: String?
    let fitnessBarrier: String?
    let fitnessGoal: String?
    let workoutExperience: String?
    let workoutLocation: String?
    let workoutDuration: String?
    let healthConcerns: [String]?
    let otherHealthConcern: String?
}
