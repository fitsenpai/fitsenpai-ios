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
    let otherHealthConcern: String?
    let dietPreference: SelectionDTO
    let otherDietPreference: String?
    let allergies: [SelectionDTO]
    let otherAllergies: [String]
    let cookingStyle: SelectionDTO
    
    enum CodingKeys: String, CodingKey {
        case id, createdAt, userId, gender, activityLevel, previousExperience, height, weight, systemOfMeasurement, birthYear, mainGoal, fitnessBarrier, fitnessGoal, workoutExperience, workoutLocation, workoutDays, workoutDuration, healthConcerns, otherHealthConcern, dietPreference, otherDietPreference, allergies, otherAllergies, cookingStyle
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Decode all your other properties normally...
        id = try container.decode(String.self, forKey: .id)
        createdAt = try container.decode(String.self, forKey: .createdAt)
        userId = try container.decode(String.self, forKey: .userId)
        gender = try container.decode(SelectionDTO.self, forKey: .gender)
        activityLevel = try container.decode(SelectionDTO.self, forKey: .activityLevel)
        previousExperience = try container.decode([SelectionDTO].self, forKey: .previousExperience)
        height = try container.decode(Int.self, forKey: .height)
        weight = try container.decode(Int.self, forKey: .weight)
        systemOfMeasurement = try container.decode(SelectionDTO.self, forKey: .systemOfMeasurement)
        birthYear = try container.decode(String.self, forKey: .birthYear)
        mainGoal = try container.decode(SelectionDTO.self, forKey: .mainGoal)
        fitnessBarrier = try container.decode(SelectionDTO.self, forKey: .fitnessBarrier)
        fitnessGoal = try container.decode(SelectionDTO.self, forKey: .fitnessGoal)
        workoutExperience = try container.decode(SelectionDTO.self, forKey: .workoutExperience)
        workoutLocation = try container.decode(SelectionDTO.self, forKey: .workoutLocation)
        workoutDays = try container.decode([SelectionDTO].self, forKey: .workoutDays)
        workoutDuration = try container.decode(SelectionDTO.self, forKey: .workoutDuration)
        healthConcerns = try container.decode([SelectionDTO].self, forKey: .healthConcerns)
        otherHealthConcern = try container.decodeIfPresent(String.self, forKey: .otherHealthConcern)
        dietPreference = try container.decode(SelectionDTO.self, forKey: .dietPreference)
        otherDietPreference = try container.decodeIfPresent(String.self, forKey: .otherDietPreference)
        allergies = try container.decode([SelectionDTO].self, forKey: .allergies)
        cookingStyle = try container.decode(SelectionDTO.self, forKey: .cookingStyle)
        
        // 👇 Handle otherAllergies as either [String] or String
        if let array = try? container.decode([String].self, forKey: .otherAllergies) {
            otherAllergies = array
        } else if let single = try? container.decode(String.self, forKey: .otherAllergies) {
            otherAllergies = [single]
        } else {
            otherAllergies = []
        }
    }
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

