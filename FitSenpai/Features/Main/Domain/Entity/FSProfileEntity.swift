//
//  FSProfileEntity.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/22/25.
//

import Foundation
import SwiftData

@Model
class FSProfileEntity {
    @Attribute(.unique) var id = UUID()
    var gender: Int?
    var activityLevel: Int?
    var mainGoal: Int?
    var height: Double?
    var weight: Double?
    var age: Int?
    var workoutExperience: Int?
    var workoutLocation: Int?
    var workoutDays: [Int]
    var workoutDuration: Int?
    var healthRestrictions: [Int]
    var otherHealthRestrictions: String?
    var diet: Int?
    var otherDiet: String?
    var allergies: [Int]
    var otherAllergies: String?
    var cookingStyle: Int?
    var pastTrainings: [Int]
    var barriers: Int?
    var goals: Int?
    var isMetric: Bool

    init(gender: Int? = nil, activityLevel: Int? = nil, mainGoal: Int? = nil, height: Double? = nil, weight: Double? = nil, age: Int? = nil, workoutExperience: Int? = nil, workoutLocation: Int? = nil, workoutDays: [Int], workoutDuration: Int? = nil, healthRestrictions: [Int], otherHealthRestrictions: String? = nil, diet: Int? = nil, otherDiet: String? = nil, allergies: [Int], otherAllergies: String? = nil, cookingStyle: Int? = nil, pastTrainings: [Int], barriers: Int? = nil, goals: Int? = nil, isMetric: Bool) {
        self.gender = gender
        self.activityLevel = activityLevel
        self.mainGoal = mainGoal
        self.height = height
        self.weight = weight
        self.age = age
        self.workoutExperience = workoutExperience
        self.workoutLocation = workoutLocation
        self.workoutDays = workoutDays
        self.workoutDuration = workoutDuration
        self.healthRestrictions = healthRestrictions
        self.otherHealthRestrictions = otherHealthRestrictions
        self.diet = diet
        self.otherDiet = otherDiet
        self.allergies = allergies
        self.otherAllergies = otherAllergies
        self.cookingStyle = cookingStyle
        self.pastTrainings = pastTrainings
        self.barriers = barriers
        self.goals = goals
        self.isMetric = isMetric
    }
    
    func toDomain() -> FSProfile {
        .init(
            gender: Gender(rawValue: gender),
            activityLevel: ActivityLevel(rawValue: activityLevel),
            mainGoal: FitnessGoals(rawValue: mainGoal),
            height: height,
            weight: weight,
            age: age,
            workoutExperience: WorkoutExperience(rawValue: workoutExperience),
            workoutLocation: WorkoutLocation(rawValue: workoutLocation),
            workoutDays: workoutDays.compactMap({ WeekDay(rawValue: $0) }),
            workoutDuration: WorkoutDuration(rawValue: workoutDuration),
            healthRestrictions: healthRestrictions.compactMap({ HealthConcern(rawValue: $0) }),
            otherHealthRestrictions: otherHealthRestrictions,
            diet: DietaryPreference(rawValue: diet),
            otherDiet: otherDiet,
            allergies: allergies.compactMap({ Allergy(rawValue: $0) }),
            otherAllergies: otherAllergies,
            cookingStyle: CookingStyle(rawValue: cookingStyle),
            pastTrainings: pastTrainings.compactMap({ PastTraining(rawValue: $0) }),
            barriers: Barriers(rawValue: barriers),
            goals: Goals(rawValue: goals),
            isMetric: isMetric
        )
    }
    
    func update(from profile: FSProfile, context: ModelContext) {
        self.gender = profile.gender?.intValue
        self.activityLevel = profile.activityLevel?.intValue
        self.mainGoal = profile.mainGoal?.intValue
        self.height = profile.height
        self.weight = profile.weight
        self.age = profile.age
        self.workoutExperience = profile.workoutExperience?.intValue
        self.workoutLocation = profile.workoutLocation?.intValue
        self.workoutDays = profile.workoutDays.map { $0.intValue }
        self.workoutDuration = profile.workoutDuration?.intValue
        self.healthRestrictions = profile.healthRestrictions.map { $0.intValue }
        self.otherHealthRestrictions = profile.otherHealthRestrictions
        self.diet = profile.diet?.intValue
        self.otherDiet = profile.otherDiet
        self.allergies = profile.allergies.map { $0.intValue }
        self.otherAllergies = profile.otherAllergies
        self.cookingStyle = profile.cookingStyle?.intValue
        self.pastTrainings = profile.pastTrainings.map { $0.intValue }
        self.barriers = profile.barriers?.intValue
        self.goals = profile.goals?.intValue
        self.isMetric = profile.isMetric
        
        try? context.save()
    }
    
    static func save(_ profile: FSProfile, context: ModelContext) {
        if let entity = try? context.fetch(FetchDescriptor<FSProfileEntity>()).first {
            entity.update(from: profile, context: context)
        }
    }
}
