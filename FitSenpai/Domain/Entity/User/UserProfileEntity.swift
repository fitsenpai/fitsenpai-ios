//
//  UserProfile.swift
//  FitSenpai
//
//  Created by Mark Daquis on 5/2/25.
//


import Foundation
import SwiftData

@Model
class UserProfileEntity {
    var id: String
    var userId: String
    var createdAt: String?
    var gender: String?
    var activityLevel: String?
    var previousExperience: [String]
    var height: Int?
    var weight: Int?
    var systemOfMeasurement: String?
    var birthYear: String?
    var mainGoal: String?
    var fitnessBarrier: String?
    var fitnessGoal: String?
    var workoutExperience: String?
    var workoutLocation: String?
    var workoutDays: [String]
    var workoutDuration: String?
    var healthConcerns: [String]
    var otherHealthConcern: String?
    var dietPreference: String?
    var otherDietPreference: String?
    var allergies: [String]
    var otherAllergies: [String]
    var cookingStyle: String?

    init(
        id: String = UUID().uuidString,
        userId: String = UUID().uuidString,
        createdAt: String? = nil,
        gender: String? = nil,
        activityLevel: String? = nil,
        previousExperience: [String]? = nil,
        height: Int? = nil,
        weight: Int? = nil,
        systemOfMeasurement: String? = nil,
        birthYear: String? = nil,
        mainGoal: String? = nil,
        fitnessBarrier: String? = nil,
        fitnessGoal: String? = nil,
        workoutExperience: String? = nil,
        workoutLocation: String? = nil,
        workoutDays: [String]? = nil,
        workoutDuration: String? = nil,
        healthConcerns: [String]? = nil,
        otherHealthConcern: String? = nil,
        dietPreference: String? = nil,
        otherDietPreference: String? = nil,
        allergies: [String]? = nil,
        otherAllergies: [String]? = nil,
        cookingStyle: String? = nil
    ) {
        self.id = id
        self.userId = userId
        self.createdAt = createdAt
        self.gender = gender
        self.activityLevel = activityLevel
        self.previousExperience = previousExperience ?? []
        self.height = height
        self.weight = weight
        self.systemOfMeasurement = systemOfMeasurement
        self.birthYear = birthYear
        self.mainGoal = mainGoal
        self.fitnessBarrier = fitnessBarrier
        self.fitnessGoal = fitnessGoal
        self.workoutExperience = workoutExperience
        self.workoutLocation = workoutLocation
        self.workoutDays = workoutDays ?? []
        self.workoutDuration = workoutDuration
        self.healthConcerns = healthConcerns ?? []
        self.otherHealthConcern = otherHealthConcern
        self.dietPreference = dietPreference
        self.otherDietPreference = otherDietPreference
        self.allergies = allergies ?? []
        self.otherAllergies = otherAllergies ?? []
        self.cookingStyle = cookingStyle
    }
    
    func toDomain() -> UserProfile {
        .init(id: id, userId: userId, createdAt: createdAt, gender: .init(id: gender), activityLevel: .init(id: activityLevel), previousExperience: previousExperience.map({ .init(id: $0 )}), height: height, weight: weight, systemOfMeasurement: .init(id: systemOfMeasurement), birthYear: birthYear, mainGoal: .init(id: mainGoal), fitnessBarrier: .init(id: fitnessBarrier), fitnessGoal: .init(id: fitnessGoal), workoutExperience: .init(id: workoutExperience), workoutLocation: .init(id: workoutLocation), workoutDays: workoutDays.map({ .init(id: $0) }), workoutDuration: .init(id: workoutDuration), healthConcerns: healthConcerns.map({ .init(id: $0)}), otherHealthConcern: otherHealthConcern, dietPreference: .init(id: dietPreference), otherDietPreference: otherDietPreference, allergies: allergies.map({ .init(id: $0) }), otherAllergies: otherAllergies, cookingStyle: .init(id: cookingStyle))
    }
    
    func update(from profile: UserProfile, context: ModelContext) {
        self.id = profile.id
        self.userId = profile.userId
        self.createdAt = profile.createdAt
        self.gender = profile.gender?.id
        self.activityLevel = profile.activityLevel?.id
        self.previousExperience = profile.previousExperience.map({ $0.id })
        self.height = profile.height
        self.weight = profile.weight
        self.systemOfMeasurement = profile.systemOfMeasurement?.id
        self.birthYear = profile.birthYear
        self.mainGoal = profile.mainGoal?.id
        self.fitnessBarrier = profile.fitnessBarrier?.id
        self.fitnessGoal = profile.fitnessGoal?.id
        self.workoutExperience = profile.workoutExperience?.id
        self.workoutLocation = profile.workoutLocation?.id
        self.workoutDays = profile.workoutDays.map({ $0.id })
        self.workoutDuration = profile.workoutDuration?.id
        self.healthConcerns = profile.healthConcerns.map({ $0.id })
        self.otherHealthConcern = profile.otherHealthConcern
        self.dietPreference = profile.dietPreference?.id
        self.otherDietPreference = profile.otherDietPreference
        self.allergies = profile.allergies.map({ $0.id })
        self.otherAllergies = profile.otherAllergies
        self.cookingStyle = profile.cookingStyle?.id
        
        try? context.save()
    }
    
    static func save(_ profile: UserProfile, context: ModelContext) {
        if let entity = try? context.fetch(FetchDescriptor<UserProfileEntity>()).first {
            entity.update(from: profile, context: context)
        } else {
            // CREATE: New entity using toEntity()
            let entity = profile.toEntity()
            context.insert(entity)
            try? context.save()
        }
    }
}
