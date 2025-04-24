import Foundation

struct UserProfileDTO: Codable {
    let userId: String
    let createdAt: Date
    let email: String
    let sex: String
    let age: Int
    let birthday: String
    let height: Double
    let heightType: String
    let weight: Double
    let weightType: String
    let hasEquipment: Bool
    let allergies: [String]
    let currentWeek: Int
    let gymActivity: Int
    let dietaryPreference: Int
    let fitnessGoals: [Int]
    let isActive: Bool
    let firstName: String
    let lastName: String
    let avatarUrl: String
    let generatedWeeks: Int
    let difficultyLevel: Int
    let workoutAdditionalNotes: String
    let id: Int
    let availedWeeks: Int
    let cuisinePreference: Int
    let workoutDays: [String]
    let mealAdditionalNotes: String
    let subcuisinePreference: Int
    let workoutDuration: String
    let weekStart: String
    let gymMembership: String
    let personalTraining: String
    let mealPlanning: String
    let hasPaid: Bool
    let initialGenerationState: String
    let checkedWorkout: String
    let checkedShopping: String
    let workoutFeedback: String
    let mealFeedback: String
    let groceryShopping: String
    let mealVariety: String
    
    enum CodingKeys: String, CodingKey {
        case userId
        case createdAt
        case email, sex, age, birthday, height, heightType, weight, weightType
        case hasEquipment, allergies, currentWeek, gymActivity, dietaryPreference
        case fitnessGoals, isActive, firstName, lastName, avatarUrl
        case generatedWeeks, difficultyLevel, workoutAdditionalNotes
        case id, availedWeeks, cuisinePreference, workoutDays, mealAdditionalNotes
        case subcuisinePreference, workoutDuration, weekStart
        case gymMembership, personalTraining, mealPlanning, hasPaid
        case initialGenerationState, checkedWorkout, checkedShopping
        case workoutFeedback, mealFeedback, groceryShopping, mealVariety
    }
    
    func toDomain() -> FitnessProfile {
        return FitnessProfile(
            gender: sex == "M" ? .male : (sex == "F" ? .female : .other),
            activityLevel: ActivityLevel(rawValue: gymActivity),
            mainGoal: fitnessGoals.first.flatMap { FitnessGoals(rawValue: $0) },
            height: height,
            weight: weight,
            age: age,
            workoutExperience: WorkoutExperience(rawValue: difficultyLevel),
            workoutLocation: hasEquipment ? .gym : .home,
            workoutDays: workoutDays.compactMap { day -> WeekDay? in
                switch day.lowercased() {
                case "sunday": return .sunday
                case "monday": return .monday
                case "tuesday": return .tuesday
                case "wednesday": return .wednesday
                case "thursday": return .thursday
                case "friday": return .friday
                case "saturday": return .saturday
                default: return nil
                }
            },
            workoutDuration: WorkoutDuration(rawValue: Int(workoutDuration) ?? 2) ?? .thirty,
            healthRestrictions: [],
            diet: DietaryPreference(rawValue: dietaryPreference),
            allergies: allergies.compactMap { allergyStr -> Allergy? in
                switch allergyStr.lowercased() {
                case "nuts": return .nuts
                case "milk and dairy": return .milkAndDairy
                case "shellfish": return .shellfish
                default: return .other
                }
            },
            cookingStyle: CookingStyle(rawValue: cuisinePreference),
            pastTrainings: [],
            barriers: nil,
            goals: nil,
            isMetric: heightType == "cm" && weightType == "kg"
        )
    }
}
