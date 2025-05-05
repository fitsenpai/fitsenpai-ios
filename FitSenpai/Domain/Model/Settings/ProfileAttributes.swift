import Foundation
import SwiftUI

// MARK: - Gender
enum Gender: String, SelectableItemProtocol {
    case male = "male"
    case female = "female"
    case other = "other"
    
    var intValue: Int {
        switch self {
        case .male: return 1
        case .female: return 2
        case .other: return 3
        }
    }
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .male: return "Male"
        case .female: return "Female"
        case .other: return "Other"
        }
    }
    
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
    case sedentary = "sedentary"
    case lightlyActive = "lightly_active"
    case moderatelyActive = "moderately_active"
    case heavilyActive = "heavily_active"
    case athlete = "athlete"
    
    var intValue: Int {
        switch self {
        case .sedentary: return 1
        case .lightlyActive: return 2
        case .moderatelyActive: return 3
        case .heavilyActive: return 4
        case .athlete: return 5
        }
    }
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .sedentary: return "Sedentary"
        case .lightlyActive: return "Light activity"
        case .moderatelyActive: return "Moderate"
        case .heavilyActive: return "Heavy training"
        case .athlete: return "Athlete"
        }
    }
    
    var subtitle: String? {
        switch self {
        case .sedentary: return "Mostly sitting, little exercise"
        case .lightlyActive: return "1-2 workouts/week"
        case .moderatelyActive: return "3-5 workouts/week"
        case .heavilyActive: return "6-7 workouts/week"
        case .athlete: return "Training 2× per day"
        }
    }
    
    var icon: ImageResource? {
        switch self {
        case .sedentary: return .icChair
        case .lightlyActive: return .icJog
        case .moderatelyActive: return .icBike
        case .heavilyActive: return .icDumble
        case .athlete: return .icSwim
        }
    }
}


enum MainGoalType: String, SelectableItemProtocol {
    case fatLoss = "fat_loss"
    case muscleGain = "muscle_gain"
    case generalFitness = "general_fitness"
    case increasedEndurance = "increased_endurance"
    case aesthetic = "aesthetic"
    
    var intValue: Int {
        switch self {
        case .fatLoss: return 1
        case .muscleGain: return 2
        case .generalFitness: return 3
        case .increasedEndurance: return 4
        case .aesthetic: return 5
        }
    }
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .fatLoss: return "Fat loss"
        case .muscleGain: return "Muscle gain"
        case .generalFitness: return "General fitness"
        case .increasedEndurance: return "Increased endurance"
        case .aesthetic: return "Aesthetic"
        }
    }
}

// MARK: - Workout Location
enum WorkoutLocationType: String, SelectableItemProtocol {
    case home = "home"
    case gym = "gym"
    case mixed = "mixed"
    
    var intValue: Int {
        switch self {
        case .home: return 1
        case .gym: return 2
        case .mixed: return 3
        }
    }
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .home: return "Home"
        case .gym: return "Gym"
        case .mixed: return "Mixed"
        }
    }
    
    var subtitle: String {
        switch self {
        case .home: return "No equipment needed"
        case .gym: return "Machine and free-weight exercises"
        case .mixed: return "Combination of home and gym"
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
enum WorkoutDurationType: String, SelectableItemProtocol {
    case fifteenMins = "15_mins"
    case thirtyMins = "30_mins"
    case fortyFiveMins = "45_mins"
    case sixtyMins = "60_mins"
    case sixtyPlusMins = "60_plus_mins"
    
    var intValue: Int {
        switch self {
        case .fifteenMins: return 1
        case .thirtyMins: return 2
        case .fortyFiveMins: return 3
        case .sixtyMins: return 4
        case .sixtyPlusMins: return 5
        }
    }
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .fifteenMins: return "15 mins"
        case .thirtyMins: return "30 mins"
        case .fortyFiveMins: return "45 mins"
        case .sixtyMins: return "60 mins"
        case .sixtyPlusMins: return "60+ mins"
        }
    }
}

// MARK: - Dietary Preference
enum DietPreferenceType: String, SelectableItemProtocol {
    case none = "none"
    case highProteinLowCarb = "high_protein_low_carb"
    case vegetarian = "vegetarian"
    case vegan = "vegan"
    case other = "other"
    
    var intValue: Int {
        switch self {
        case .none: return 1
        case .highProteinLowCarb: return 2
        case .vegetarian: return 3
        case .vegan: return 4
        case .other: return 5
        }
    }
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .none: return "None"
        case .highProteinLowCarb: return "High protein, low carb"
        case .vegetarian: return "Vegetarian"
        case .vegan: return "Vegan"
        case .other: return "Other"
        }
    }
    
    var icon: ImageResource? {
        switch self {
        case .none: return .icX
        case .highProteinLowCarb: return .icFish
        case .vegetarian: return .icOrange
        case .vegan: return .icLeaves
        case .other: return .icDots
        }
    }
}

// MARK: - Allergy
enum AllergyType: String, SelectableItemProtocol {
    case none = "none"
    case nuts = "nuts"
    case dairy = "dairy"
    case shellfish = "shellfish"
    case other = "other"
    
    var intValue: Int {
        switch self {
        case .none: return 1
        case .nuts: return 2
        case .dairy: return 3
        case .shellfish: return 4
        case .other: return 5
        }
    }
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .none: return "None"
        case .nuts: return "Nuts"
        case .dairy: return "Dairy"
        case .shellfish: return "Shellfish"
        case .other: return "Other"
        }
    }
    
    var icon: ImageResource? {
        switch self {
        case .none: return .icX
        case .nuts: return .icNuts
        case .dairy: return .icCheese
        case .shellfish: return .icShrimp
        case .other: return .icDots
        }
    }
}

// MARK: - WeekDay
enum WeekDayType: String, SelectableItemProtocol {
    case sunday = "sunday"
    case monday = "monday"
    case tuesday = "tuesday"
    case wednesday = "wednesday"
    case thursday = "thursday"
    case friday = "friday"
    case saturday = "saturday"
    
    var intValue: Int {
        switch self {
        case .sunday: return 1
        case .monday: return 2
        case .tuesday: return 3
        case .wednesday: return 4
        case .thursday: return 5
        case .friday: return 6
        case .saturday: return 7
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
enum HealthConcernType: String, SelectableItemProtocol {
    case none = "none"
    case jointPain = "joint_pain"
    case backIssues = "back_issues"
    case heartCondition = "heart_condition"
    case other = "other"
    
    var intValue: Int {
        switch self {
        case .none: return 1
        case .jointPain: return 2
        case .backIssues: return 3
        case .heartCondition: return 4
        case .other: return 5
        }
    }
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .none: return "None"
        case .jointPain: return "Joint pain"
        case .backIssues: return "Back issues"
        case .heartCondition: return "Heart condition"
        case .other: return "Other"
        }
    }
    
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

enum PreviousExperienceType: String, SelectableItemProtocol {
    case personalTrainers = "personal_trainers"
    case fitnessApps = "fitness_apps"
    case workoutVideos = "workout_videos"
    case mealDietPrograms = "meal_diet_programs"
    case none = "none"
    
    var intValue: Int {
        switch self {
        case .personalTrainers: return 1
        case .fitnessApps: return 2
        case .workoutVideos: return 3
        case .mealDietPrograms: return 4
        case .none: return 5
        }
    }

    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .personalTrainers: return "Personal trainers"
        case .fitnessApps: return "Fitness apps"
        case .workoutVideos: return "Workout videos"
        case .mealDietPrograms: return "Meal/diet programs"
        case .none: return "None"
        }
    }
    
    var icon: ImageResource? {
        switch self {
        case .personalTrainers: return .icHandshake
        case .fitnessApps: return .icPhone
        case .workoutVideos: return .icPlayWorkout
        case .mealDietPrograms: return .icSpoonFork
        case .none: return .icX
        }
    }
}

enum WorkoutExperienceType: String, SelectableItemProtocol {
    case beginner = "beginner"
    case intermediate = "intermediate"
    case advanced = "advanced"
    
    var intValue: Int {
        switch self {
        case .beginner: return 1
        case .intermediate: return 2
        case .advanced: return 3
        }
    }
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .beginner: return "Beginner"
        case .intermediate: return "Intermediate"
        case .advanced: return "Advanced"
        }
    }
    
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

enum FitnessBarrierType: String, SelectableItemProtocol {
    case lackOfConsistency = "lack_of_consistency"
    case unhealthyEating = "unhealthy_eating"
    case expense = "expense"
    case lackOfEquipment = "lack_of_equipment"
    case busySchedule = "busy_schedule"
    case lackOfDirection = "lack_of_direction"
    
    var intValue: Int {
        switch self {
        case .lackOfConsistency: return 1
        case .unhealthyEating: return 2
        case .expense: return 3
        case .lackOfEquipment: return 4
        case .busySchedule: return 5
        case .lackOfDirection: return 6
        }
    }
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .lackOfConsistency: return "Lack of consistency"
        case .unhealthyEating: return "Unhealthy eating"
        case .expense: return "Expense"
        case .lackOfEquipment: return "Lack of equipment"
        case .busySchedule: return "Busy schedule"
        case .lackOfDirection: return "Lack of direction"
        }
    }
    
    var icon: ImageResource? {
        switch self {
        case .lackOfConsistency: return .icLineChartDown
        case .unhealthyEating: return .icBurger
        case .expense: return .icCurrency
        case .lackOfEquipment: return .icDumble
        case .busySchedule: return .icCalendarX
        case .lackOfDirection: return .icSmileyMelting
        }
    }
}

enum FitnessGoalType: String, SelectableItemProtocol {
    case motivationConsistency = "motivation_consistency"
    case healthierLifestyle = "healthier_lifestyle"
    case budgetFitness = "budget_fitness"
    case energyMood = "energy_mood"
    case bodyImage = "body_image"
    
    var intValue: Int {
        switch self {
        case .motivationConsistency: return 1
        case .healthierLifestyle: return 2
        case .budgetFitness: return 3
        case .energyMood: return 4
        case .bodyImage: return 5
        }
    }
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .motivationConsistency: return "Motivation & consistency"
        case .healthierLifestyle: return "Healthier lifestyle"
        case .budgetFitness: return "Budget fitness"
        case .energyMood: return "Energy & mood"
        case .bodyImage: return "Body image"
        }
    }
    
    var icon: ImageResource? {
        switch self {
        case .motivationConsistency: return .icLineChart
        case .healthierLifestyle: return .icCarrot
        case .budgetFitness: return .icPiggy
        case .energyMood: return .icSun
        case .bodyImage: return .icSparkle
        }
    }
}

enum CookingStyleType: String, SelectableItemProtocol {
    case quickEasy = "quick_easy"
    case enjoyCooking = "enjoy_cooking"
    case simpleMeals = "simple_meals"
    case orderFood = "order_food"
    
    var intValue: Int {
        switch self {
        case .quickEasy: return 1
        case .enjoyCooking: return 2
        case .simpleMeals: return 3
        case .orderFood: return 4
        }
    }
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .quickEasy: return "Quick & easy"
        case .enjoyCooking: return "I enjoy cooking"
        case .simpleMeals: return "Simple meals only"
        case .orderFood: return "Mostly order food"
        }
    }
    
    var icon: ImageResource? {
        switch self {
        case .quickEasy: return .iconTimer
        case .enjoyCooking: return .iconCooking
        case .simpleMeals: return .iconListNumber
        case .orderFood: return .iconCart
        }
    }
}

enum MeasurementType: String {
    case imperial = "imperial"
    case metric = "metric"
    
    func toOption() -> OptionItem {
        switch self {
        case .metric:
            return OptionItem(id: "metric", name: "Metric")
        case .imperial:
            return OptionItem(id: "imperial", name: "Imperial")
        }
    }
}

