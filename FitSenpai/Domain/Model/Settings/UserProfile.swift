//
//  UserProfile.swift
//  FitSenpai
//
//  Created by Mark Daquis on 5/2/25.
//


import Foundation

struct UserProfile {
    var id: String
    var userId: String
    var createdAt: String?
    var gender: OptionItem?
    var activityLevel: OptionItem?
    var previousExperience: [OptionItem]
    var height: Int?
    var weight: Int?
    var systemOfMeasurement: OptionItem?
    var birthYear: String?
    var mainGoal: OptionItem?
    var fitnessBarrier: OptionItem?
    var fitnessGoal: OptionItem?
    var workoutExperience: OptionItem?
    var workoutLocation: OptionItem?
    var workoutDays: [OptionItem]
    var workoutDuration: OptionItem?
    var healthConcerns: [OptionItem]
    var otherHealthConcern: String?
    var dietPreference: OptionItem?
    var otherDietPreference: String?
    var allergies: [OptionItem]
    var otherAllergies: [String]
    var cookingStyle: OptionItem?

    init(
        id: String = UUID().uuidString,
        userId: String = UUID().uuidString,
        createdAt: String? = nil,
        gender: OptionItem? = nil,
        activityLevel: OptionItem? = nil,
        previousExperience: [OptionItem] = [],
        height: Int? = nil,
        weight: Int? = nil,
        systemOfMeasurement: OptionItem? = nil,
        birthYear: String? = nil,
        mainGoal: OptionItem? = nil,
        fitnessBarrier: OptionItem? = nil,
        fitnessGoal: OptionItem? = nil,
        workoutExperience: OptionItem? = nil,
        workoutLocation: OptionItem? = nil,
        workoutDays: [OptionItem] = [],
        workoutDuration: OptionItem? = nil,
        healthConcerns: [OptionItem] = [],
        otherHealthConcern: String? = nil,
        dietPreference: OptionItem? = nil,
        otherDietPreference: String? = nil,
        allergies: [OptionItem] = [],
        otherAllergies: [String] = [],
        cookingStyle: OptionItem? = nil
    ) {
        self.id = id
        self.userId = userId
        self.createdAt = createdAt
        self.gender = gender
        self.activityLevel = activityLevel
        self.previousExperience = previousExperience
        self.height = height
        self.weight = weight
        self.systemOfMeasurement = systemOfMeasurement
        self.birthYear = birthYear
        self.mainGoal = mainGoal
        self.fitnessBarrier = fitnessBarrier
        self.fitnessGoal = fitnessGoal
        self.workoutExperience = workoutExperience
        self.workoutLocation = workoutLocation
        self.workoutDays = workoutDays
        self.workoutDuration = workoutDuration
        self.healthConcerns = healthConcerns
        self.otherHealthConcern = otherHealthConcern
        self.dietPreference = dietPreference
        self.otherDietPreference = otherDietPreference
        self.allergies = allergies
        self.otherAllergies = otherAllergies
        self.cookingStyle = cookingStyle
    }
    
    
    func toEntity() -> UserProfileEntity {
        let entity = UserProfileEntity()
        entity.id = self.id
        entity.userId = self.userId
        entity.createdAt = self.createdAt
        entity.gender = self.gender?.id
        entity.activityLevel = self.activityLevel?.id
        entity.previousExperience = self.previousExperience.map({ $0.id }).joined(separator: ",")
        entity.height = self.height
        entity.weight = self.weight
        entity.systemOfMeasurement = self.systemOfMeasurement?.id
        entity.birthYear = self.birthYear
        entity.mainGoal = self.mainGoal?.id
        entity.fitnessBarrier = self.fitnessBarrier?.id
        entity.fitnessGoal = self.fitnessGoal?.id
        entity.workoutExperience = self.workoutExperience?.id
        entity.workoutLocation = self.workoutLocation?.id
        entity.workoutDays = self.workoutDays.map({ $0.id }).joined(separator: ",")
        entity.workoutDuration = self.workoutDuration?.id
        entity.healthConcerns = self.healthConcerns.map({ $0.id }).joined(separator: ",")
        entity.otherHealthConcern = self.otherHealthConcern
        entity.dietPreference = self.dietPreference?.id
        entity.otherDietPreference = self.otherDietPreference
        entity.allergies = self.allergies.map({ $0.id }).joined(separator: ",")
        entity.otherAllergies = self.otherAllergies.joined(separator: ",")
        entity.cookingStyle = self.cookingStyle?.id
        return entity
    }
    
    func toRequestBody() -> WorkoutProfileRequest {
        
        return WorkoutProfileRequest(
            gender: gender?.id,
            genderOther: gender?.id == "other" ? "other": nil,
            activityLevel: activityLevel?.id,
            previousExperience: previousExperience.map { $0.id },
            height_cm: Double(height ?? 0),
            weight_kg: Double(weight ?? 0),
            birthYear: birthYear,
            mainGoal: mainGoal?.id,
            fitnessBarrier: fitnessBarrier?.id,
            fitnessGoal: fitnessGoal?.id,
            workoutExperience: workoutExperience?.id,
            workoutLocation: workoutLocation?.id,
            workoutDuration: workoutDuration?.id,
            healthConcerns: healthConcerns.map { $0.id },
            otherHealthConcern: otherHealthConcern,
            cookingStyle: cookingStyle?.id,
            workoutDays: workoutDays.map { $0.id },
            dietPreference: dietPreference?.id,
            otherDietPreference: otherDietPreference,
            allergies: allergies.map { $0.id },
            otherAllergies: otherAllergies.joined(separator: ",")
        )
    }
}


struct OptionItem: Codable {
    let id: String
    let name: String
    let description: String?
    
    init(id: String?, name: String = "", description: String? = nil) {
        self.id = id ?? UUID().uuidString
        self.name = name
        self.description = description
    }
}
