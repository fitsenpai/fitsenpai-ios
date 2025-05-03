import Foundation

struct UserProfileDTO: Codable {
    let id: String
    let createdAt: String
    let userId: String
    let gender: SelectionDTO
    let activityLevel: SelectionDTO
    let previousExperience: [SelectionDTO]
    let height: Int
    let weight: Int
    let systemOfMeasurement: SelectionDTO
    let birthYear: String
    let mainGoal: SelectionDTO
    let fitnessBarrier: SelectionDTO
    let fitnessGoal: SelectionDTO
    let workoutExperience: SelectionDTO
    let workoutLocation: SelectionDTO
    let workoutDays: [SelectionDTO]
    let workoutDuration: SelectionDTO
    let healthConcerns: [SelectionDTO]
    let otherHealthConcern: String
    let dietPreference: SelectionDTO
    let otherDietPreference: String
    let allergies: [SelectionDTO]
    let otherAllergies: [String]
    let cookingStyle: SelectionDTO
}

extension UserProfileDTO {
    func toDomain() -> UserProfile {
        return UserProfile(
            id: id,
            userId: userId, createdAt: createdAt,
            gender: gender.toDomain(),
            activityLevel: activityLevel.toDomain(),
            previousExperience: previousExperience.map { $0.toDomain() },
            height: height,
            weight: weight,
            systemOfMeasurement: systemOfMeasurement.toDomain(),
            birthYear: birthYear,
            mainGoal: mainGoal.toDomain(),
            fitnessBarrier: fitnessBarrier.toDomain(),
            fitnessGoal: fitnessGoal.toDomain(),
            workoutExperience: workoutExperience.toDomain(),
            workoutLocation: workoutLocation.toDomain(),
            workoutDays: workoutDays.map { $0.toDomain() },
            workoutDuration: workoutDuration.toDomain(),
            healthConcerns: healthConcerns.map { $0.toDomain() },
            otherHealthConcern: otherHealthConcern,
            dietPreference: dietPreference.toDomain(),
            otherDietPreference: otherDietPreference,
            allergies: allergies.map { $0.toDomain() },
            otherAllergies: otherAllergies,
            cookingStyle: cookingStyle.toDomain()
        )
    }
}

struct SelectionDTO: Codable {
    let id: String
    let name: String
    let description: String?
}

extension SelectionDTO {
    func toDomain() -> OptionItem {
        return OptionItem(
            id: id,
            name: name,
            description: description
        )
    }
}

