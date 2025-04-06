import Foundation

// MARK: - Gender
enum Gender: String, CaseIterable, Identifiable {
    case male = "Male"
    case female = "Female"
    case other = "Other"
    
    var id: String { rawValue }
    
    var iconName: String {
        switch self {
        case .male: return "ic_male"
        case .female: return "ic_female"
        case .other: return "ic_dots"
        }
    }
}

// MARK: - Activity Level
enum ActivityLevel: String, CaseIterable, Identifiable {
    case sedentary = "Sedentary"
    case light = "Light activity"
    case moderate = "Moderate"
    case heavy = "Heavy training"
    case athlete = "Athlete"
    
    var id: String { rawValue }
    
    var description: String {
        switch self {
        case .sedentary: return "Mostly sitting, little exercise"
        case .light: return "1-2 workouts/week"
        case .moderate: return "3-5 workouts/week"
        case .heavy: return "6-7 workouts/week"
        case .athlete: return "Training 2× per day"
        }
    }
    
    var iconName: String {
        switch self {
        case .sedentary: return "ic_chair"
        case .light: return "ic_jog"
        case .moderate: return "ic_bike"
        case .heavy: return "ic_dumble"
        case .athlete: return "ic_swim"
        }
    }
}

enum FitnessGoals: String, CaseIterable, Identifiable {
    case fatLoss = "Fat loss"
    case muscleGain = "Muscle gain"
    case generalFitness = "General fitness"
    case increasedEndurance = "Increased endurance"
    case aesthetic = "Aesthetic"
    
    var id: String { rawValue }
    
    var iconName: String {
        switch self {
        case .fatLoss: return "ic_line_chart_down"
        case .muscleGain: return "ic_dumble"
        case .generalFitness: return "ic_sparkle"
        case .increasedEndurance: return "ic_lightning"
        case .aesthetic: return "ic_sparkle"
        }
    }
}

// MARK: - Workout Location
enum WorkoutLocation: String, CaseIterable, Identifiable {
    case home = "Home"
    case gym = "Gym"
    case mixed = "Mixed"
    
    var id: String { rawValue }
    
    var subtitle: String {
        switch self {
        case .home: return "No equipment needed"
        case .gym: return "Machine and free-weight exercises"
        case .mixed: return "Combination of home and gym workouts"
        }
    }
    
    var iconName: String {
        switch self {
        case .home: return "ic_house"
        case .gym: return "ic_building"
        case .mixed: return "ic_arrows"
        }
    }
}

// MARK: - Workout Duration
enum WorkoutDuration: String, CaseIterable, Identifiable {
    case fifteen = "15 mins"
    case thirty = "30 mins"
    case fortyFive = "45 mins"
    case sixty = "60 mins"
    case more = "60+ mins"
    
    var id: String { rawValue }
}

// MARK: - Exercise Difficulty
enum ExerciseDifficulty: String, CaseIterable, Identifiable {
    case beginner = "Beginner"
    case intermediate = "Intermediate"
    case advanced = "Advanced"
    
    var id: String { rawValue }
    
    var subtitle: String {
        switch self {
        case .beginner: return "I'm new to fitness"
        case .intermediate: return "I workout from time to time"
        case .advanced: return "I exercise regularly"
        }
    }
    
    var iconName: String {
        switch self {
        case .beginner: return "ic_jog"
        case .intermediate: return "ic_dumble"
        case .advanced: return "ic_lightning"
        }
    }
}

// MARK: - Dietary Preference
enum DietaryPreference: String, CaseIterable, Identifiable {
    case none = "None"
    case highProtein = "High protein, low carb"
    case vegetarian = "Vegetarian"
    case vegan = "Vegan"
    case other = "Other"
    
    var id: String { rawValue }
    
    var iconName: String {
        switch self {
        case .none: return "ic_x"
        case .highProtein: return "ic_fish"
        case .vegetarian: return "ic_orange"
        case .vegan: return "ic_leaves"
        case .other: return "ic_dots"
        }
    }
}

// MARK: - Allergy
enum Allergy: String, CaseIterable, Identifiable {
    case none = "None"
    case nuts = "Nuts"
    case milkAndDairy = "Milk and dairy"
    case shellfish = "Shellfish"
    case other = "Other"
    
    var id: String { rawValue }
    
    var iconName: String {
        switch self {
        case .none: return "ic_x"
        case .nuts: return "ic_nuts"
        case .milkAndDairy: return "ic_cheese"
        case .shellfish: return "ic_shrimp"
        case .other: return "ic_dots"
        }
    }
}

// MARK: - WeekDay
enum WeekDay: Int, CaseIterable, Identifiable {
    case sunday = 0
    case monday = 1
    case tuesday = 2
    case wednesday = 3
    case thursday = 4
    case friday = 5
    case saturday = 6
    
    var id: Int { rawValue }
    
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
enum HealthConcern: String, CaseIterable, Identifiable {
    case none = "None"
    case jointPain = "Joint pain"
    case backIssues = "Back issues"
    case heartCondition = "Heart condition"
    case other = "Other"
    
    var id: String { rawValue }
    
    var iconName: String {
        switch self {
        case .none: return "ic_x"
        case .jointPain: return "ic_bone"
        case .backIssues: return "ic_hike"
        case .heartCondition: return "ic_heart_2"
        case .other: return "ic_dots"
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
