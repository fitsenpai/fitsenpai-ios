import Foundation
import SwiftUI

// MARK: - Gender
enum Gender: String, SelectableItemProtocol {
    case male = "Male"
    case female = "Female"
    case other = "Other"
    
    var id: String { rawValue }
    
    var title: String { rawValue }
    
    var icon: ImageResource? {
        switch self {
        case .male: return .icMale
        case .female: return .icFemale
        case .other: return .icDots
        }
    }
}

// MARK: - Activity Level
enum ActivityLevel: String, SelectableItemProtocol {
    case sedentary = "Sedentary"
    case light = "Light activity"
    case moderate = "Moderate"
    case heavy = "Heavy training"
    case athlete = "Athlete"
    
    var id: String { rawValue }
    
    var title: String { rawValue }
    
    var subtitle: String? {
        switch self {
        case .sedentary: return "Mostly sitting, little exercise"
        case .light: return "1-2 workouts/week"
        case .moderate: return "3-5 workouts/week"
        case .heavy: return "6-7 workouts/week"
        case .athlete: return "Training 2× per day"
        }
    }
    
    var icon: ImageResource? {
        switch self {
        case .sedentary: return .icChair
        case .light: return .icJog
        case .moderate: return .icBike
        case .heavy: return .icDumble
        case .athlete: return .icSwim
        }
    }
}

enum FitnessGoals: String, SelectableItemProtocol {
    case fatLoss = "Fat loss"
    case muscleGain = "Muscle gain"
    case generalFitness = "General fitness"
    case increasedEndurance = "Increased endurance"
    case aesthetic = "Aesthetic"
    
    var id: String { rawValue }
    
    var title: String { rawValue }
}

// MARK: - Workout Location
enum WorkoutLocation: String, SelectableItemProtocol {
    case home = "Home"
    case gym = "Gym"
    case mixed = "Mixed"
    
    var id: String { rawValue }
    
    var title: String { rawValue }
    
    var subtitle: String {
        switch self {
        case .home: return "No equipment needed"
        case .gym: return "Machine and free-weight exercises"
        case .mixed: return "Combination of home and gym workouts"
        }
    }
    
    var icon: ImageResource? {
        switch self {
        case .home: return .icHouse
        case .gym: return .icBuilding
        case .mixed: return .icArrows
        }
    }
}

// MARK: - Workout Duration
enum WorkoutDuration: String, SelectableItemProtocol {
    case fifteen = "15 mins"
    case thirty = "30 mins"
    case fortyFive = "45 mins"
    case sixty = "60 mins"
    case more = "60+ mins"
    
    var id: String { rawValue }
    
    var title: String { rawValue }
}

// MARK: - Exercise Difficulty
enum ExerciseDifficulty: String, SelectableItemProtocol {
    case beginner = "Beginner"
    case intermediate = "Intermediate"
    case advanced = "Advanced"
    
    var id: String { rawValue }
    
    var title: String { rawValue }
    
    var subtitle: String {
        switch self {
        case .beginner: return "I'm new to fitness"
        case .intermediate: return "I workout from time to time"
        case .advanced: return "I exercise regularly"
        }
    }
    
    var icon: ImageResource? {
        switch self {
        case .beginner: return .icJog
        case .intermediate: return .icDumble
        case .advanced: return .icLightning
        }
    }
}

// MARK: - Dietary Preference
enum DietaryPreference: String, SelectableItemProtocol {
    case none = "None"
    case highProtein = "High protein, low carb"
    case vegetarian = "Vegetarian"
    case vegan = "Vegan"
    case other = "Other"
    
    var id: String { rawValue }
    
    var title: String { rawValue }

    var icon: ImageResource? {
        switch self {
        case .none: return .icX
        case .highProtein: return .icFish
        case .vegetarian: return .icOrange
        case .vegan: return .icLeaves
        case .other: return .icDots
        }
    }
}

// MARK: - Allergy
enum Allergy: String, SelectableItemProtocol {
    case none = "None"
    case nuts = "Nuts"
    case milkAndDairy = "Milk and dairy"
    case shellfish = "Shellfish"
    case other = "Other"
    
    var id: String { rawValue }
    
    var title: String { rawValue }

    var icon: ImageResource? {
        switch self {
        case .none: return .icX
        case .nuts: return .icNuts
        case .milkAndDairy: return .icCheese
        case .shellfish: return .icShrimp
        case .other: return .icDots
        }
    }
}

// MARK: - WeekDay
enum WeekDay: Int, SelectableItemProtocol {
    case sunday = 0
    case monday = 1
    case tuesday = 2
    case wednesday = 3
    case thursday = 4
    case friday = 5
    case saturday = 6
    
    var id: Int { rawValue }
    
    var title: String { shortName }
    
    var shortName: String {
        switch self {
        case .sunday: return "S"
        case .monday: return "M"
        case .tuesday: return "T"
        case .wednesday: return "W"
        case .thursday: return "Th"
        case .friday: return "F"
        case .saturday: return "S"
        }
    }
    
    var fullName: String {
        switch self {
        case .sunday: return "Sunday"
        case .monday: return "Monday"
        case .tuesday: return "Tuesday"
        case .wednesday: return "Wednesday"
        case .thursday: return "Thursday"
        case .friday: return "Friday"
        case .saturday: return "Saturday"
        }
    }
}

// MARK: - Health Concern
enum HealthConcern: String, SelectableItemProtocol {
    case none = "None"
    case jointPain = "Joint pain"
    case backIssues = "Back issues"
    case heartCondition = "Heart condition"
    case other = "Other"
    
    var id: String { rawValue }
    
    var title: String { rawValue }
    
    var icon: ImageResource? {
        switch self {
        case .none: return .icX
        case .jointPain: return .icBone
        case .backIssues: return .icHike
        case .heartCondition: return .icHeart2
        case .other: return .icDots
        }
    }
}

// MARK: - User Details
struct UserDetails {
    var name: String
    var age: Int
    var gender: Gender
    var activityLevel: ActivityLevel
    var fitnessGoal: FitnessGoals
}
