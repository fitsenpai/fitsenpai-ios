import Foundation
import SwiftUI

// MARK: - Gender
enum Gender: String, SelectableItemProtocol {
    case male = "Male"
    case female = "Female"
    case other = "Other"
    
    init?(rawValue: Int?) {
        switch rawValue {
        case 1: self = .male
        case 2: self = .female
        case 3: self = .other
        default: return nil
        }
    }
    
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
    
    init?(rawValue: Int?) {
        switch rawValue {
        case 1: self = .sedentary
        case 2: self = .light
        case 3: self = .moderate
        case 4: self = .heavy
        case 5: self = .athlete
        default: return nil
        }
    }
    
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
    
    init?(rawValue: Int?) {
        switch rawValue {
        case 1: self = .fatLoss
        case 2: self = .muscleGain
        case 3: self = .generalFitness
        case 4: self = .increasedEndurance
        case 5: self = .aesthetic
        default: return nil
        }
    }
    
    var id: String { rawValue }
    
    var title: String { rawValue }
}

// MARK: - Workout Location
enum WorkoutLocation: String, SelectableItemProtocol {
    case home = "Home"
    case gym = "Gym"
    case mixed = "Mixed"
    
    init?(rawValue: Int?) {
        switch rawValue {
        case 1: self = .home
        case 2: self = .gym
        case 3: self = .mixed
        default: return nil
        }
    }
    
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
    
    init?(rawValue: Int?) {
        switch rawValue {
        case 1: self = .fifteen
        case 2: self = .thirty
        case 3: self = .fortyFive
        case 4: self = .sixty
        case 5: self = .more
        default: return nil
        }
    }
    
    var id: String { rawValue }
    
    var title: String { rawValue }
}


// MARK: - Dietary Preference
enum DietaryPreference: String, SelectableItemProtocol {
    case none = "None"
    case highProtein = "High protein, low carb"
    case vegetarian = "Vegetarian"
    case vegan = "Vegan"
    case other = "Other"
    
    init?(rawValue: Int?) {
        switch rawValue {
        case 1: self = .none
        case 2: self = .highProtein
        case 3: self = .vegetarian
        case 4: self = .vegan
        case 5: self = .other
        default: return nil
        }
    }
    
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
    
    init?(rawValue: Int?) {
        switch rawValue {
        case 1: self = .none
        case 2: self = .nuts
        case 3: self = .milkAndDairy
        case 4: self = .shellfish
        case 5: self = .other
        default: return nil
        }
    }
    
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
enum WeekDay: String, SelectableItemProtocol {
    case sunday
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    
    init?(rawValue: Int?) {
        switch rawValue {
        case 1: self = .sunday
        case 2: self = .monday
        case 3: self = .tuesday
        case 4: self = .wednesday
        case 5: self = .thursday
        case 6: self = .friday
        case 7: self = .saturday
        default: return nil
        }
    }
    
    var id: String { rawValue }
    
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
    
    init?(rawValue: Int?) {
        switch rawValue {
        case 1: self = .none
        case 2: self = .jointPain
        case 3: self = .backIssues
        case 4: self = .heartCondition
        case 5: self = .other
        default: return nil
        }
    }
    
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

enum PastTraining: String, SelectableItemProtocol {
    
    case personalTrainers = "Personal trainers"
    case fitnessApps = "Joint pain"
    case workoutVideos = "Back issues"
    case program = "Heart condition"
    case none = "None"
    
    init?(rawValue: Int?) {
        switch rawValue {
        case 1: self = .personalTrainers
        case 2: self = .fitnessApps
        case 3: self = .workoutVideos
        case 4: self = .program
        case 5: self = .none
        default: return nil
        }
    }
    
    var id: String { rawValue }
    
    var title: String { rawValue }
    
    var icon: ImageResource? {
        switch self {
        case .personalTrainers:
            return .icHandshake
        case .fitnessApps:
            return .icPhone
        case .workoutVideos:
            return .icPlayWorkout
        case .program:
            return .icSpoonFork
        case .none:
            return .icX
        }
    }
}

enum WorkoutExperience: String, SelectableItemProtocol {
    case beginner = "Beginner"
    case intermediate = "Intermediate"
    case advanced = "Advanced"
    
    init?(rawValue: Int?) {
        switch rawValue {
        case 1: self = .beginner
        case 2: self = .intermediate
        case 3: self = .advanced
        default: return nil
        }
    }
    
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

enum Barriers: String, SelectableItemProtocol {
    case consistency = "Lack of consistency"
    case eatingHabits = "Unhealthy eating habits"
    case expensive = "Fitness is too expensive"
    case busy = "Busy schedule"
    case unsure = "Not sure where to start"
    
    init?(rawValue: Int?) {
        switch rawValue {
        case 1: self = .consistency
        case 2: self = .eatingHabits
        case 3: self = .expensive
        case 4: self = .busy
        case 5: self = .unsure
        default: return nil
        }
    }
    
    var id: String { rawValue }
    
    var title: String { rawValue }
    
    var icon: ImageResource? {
        switch self {
        case .consistency: return .icLineChartDown
        case .eatingHabits: return .icBurger
        case .expensive: return .icCurrency
        case .busy: return .icCalendarX
        case .unsure: return .icSmileyMelting
        }
    }
}

enum Goals: String, SelectableItemProtocol {
    case motivation = "Stay motivated and consistent"
    case healthyLiving = "Eat and live healthier"
    case saveMoney = "Save money while getting fit"
    case energy = "Boost my energy and mood"
    case confidence = "Feel better about my body"
    
    init?(rawValue: Int?) {
        switch rawValue {
        case 1: self = .motivation
        case 2: self = .healthyLiving
        case 3: self = .saveMoney
        case 4: self = .energy
        case 5: self = .confidence
        default: return nil
        }
    }
    
    var id: String { rawValue }
    
    var title: String { rawValue }
    
    var icon: ImageResource? {
        switch self {
        case .motivation: return .icLineChart
        case .healthyLiving: return .icCarrot
        case .saveMoney: return .icPiggy
        case .energy: return .icSun
        case .confidence: return .icSparkle
        }
    }
}

enum CookingStyle: String, SelectableItemProtocol {
    case quick = "Quick & easy"
    case enjoyCooking = "I enjoy cooking"
    case simple = "Simple meals only"
    case orderFood = "Mostly order food"
    
    init?(rawValue: Int?) {
        switch rawValue {
        case 1: self = .quick
        case 2: self = .enjoyCooking
        case 3: self = .simple
        case 4: self = .orderFood
        default: return nil
        }
    }
    
    var id: String { rawValue }
    
    var title: String { rawValue }
    
    var icon: ImageResource? {
        switch self {
        case .quick: return .iconTimer
        case .enjoyCooking: return .iconCooking
        case .simple: return .iconListNumber
        case .orderFood: return .iconCart
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
