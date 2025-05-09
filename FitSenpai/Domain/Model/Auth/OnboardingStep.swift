import SwiftUI

enum StepType {
    case selection(isMultiple: Bool)
    case heightWeight
    case age
    case macro
    case testimonial
    case notification
    case enableNnotification
    case saveMoney
    case input(previousStep: StepID, placeholder: String)
}

enum StepID: String {
    case gender
    case activityLevel
    case pastTraining
    case testimonial
    case measurements
    case age
    case mainGoal
    case macroBreakdown
    case barriers
    case goals
    case saveMoney
    case workoutExperience
    case workoutLocation
    case workoutDays
    case workoutDuration
    case healthRestrictions
    case healthRestrictionsInput
    case diet
    case dietInput
    case allergies
    case allergiesInput
    case cookingStyle
    case notifications
    case enableNotifications
}

struct OnboardingStep {
    let id: StepID
    let title: String
    let subtitle: String?
    let options: [SelectionItem]
    let type: StepType
    
    var showsButton: Bool {
        switch type {
        case .notification, .enableNnotification:
            return false
        case .selection(let isMultiple):
            return isMultiple
        default:
            return true
        }
    }
    
    var isHeightWeightStep: Bool {
        if case .heightWeight = type { return true }
        return false
    }
    
    var isAgeStep: Bool {
        if case .age = type { return true }
        return false
    }
    
    var isMacroStep: Bool {
        if case .macro = type { return true }
        return false
    }
    
    var isTestimonialStep: Bool {
        if case .testimonial = type { return true }
        return false
    }
    
    var isNotificationStep: Bool {
        if case .notification = type { return true }
        return false
    }
    
    var isSaveMoneyStep: Bool {
        if case .saveMoney = type { return true }
        return false
    }
    
    var isInputStep: Bool {
        if case .input(_, _) = type { return true }
        return false
    }
    
    var buttonTitle: String? {
        switch id {
        case .pastTraining, .measurements, .age, .workoutDays,
                .healthRestrictions, .allergies, .healthRestrictionsInput,
                .dietInput, .allergiesInput, .diet:
                return "Next"
            default:
                return "Continue"
        }
    }
    
    static let steps: [OnboardingStep] = [
        // Gender Selection
        .init(
            id: .gender,
            title: "Choose your gender",
            subtitle: "This will be used to personalize your plan.",
            options: [
                .init(id: 1, stringId: "male", title: "Male", icon: .iconMale),
                .init(id: 2, stringId: "female", title: "Female", icon: .iconFemale),
                .init(id: 3, stringId: "other", title: "Other", icon: .iconDots)
            ],
            type: .selection(isMultiple: false)
        ),
        
        // Daily Activity Level
        .init(
            id: .activityLevel,
            title: "How active are you daily?",
            subtitle: nil,
            options: [
                .init(id: 1, stringId: "sedentary", title: "Sedentary", subtitle: "Mostly sitting, little exercise", icon: .iconChair),
                .init(id: 2, stringId: "lightly_active", title: "Light activity", subtitle: "1-2 exercises/week", icon: .iconWalk),
                .init(id: 3, stringId: "moderately_active", title: "Moderate", subtitle: "3-5 exercises/week", icon: .iconBike),
                .init(id: 4, stringId: "heavily_active", title: "Heavy training", subtitle: "6-7 exercises/week", icon: .iconBarbell),
                .init(id: 5, stringId: "athlete", title: "Athlete", subtitle: "Training 2x per day", icon: .iconSwim)
            ],
            type: .selection(isMultiple: false)
        ),
        
        // Past Training Experience
        .init(
            id: .pastTraining,
            title: "Which of these have you tried in the past?",
            subtitle: nil,
            options: [
                .init(id: 1, stringId: "personal_trainers", title: "Personal trainers", icon: .iconHandshake),
                .init(id: 2, stringId: "fitness_apps", title: "Fitness apps", icon: .iconDevice),
                .init(id: 3, stringId: "workout_videos", title: "Workout videos", icon: .iconVideo),
                .init(id: 4, stringId: "meal_diet_programs", title: "Meal plans or diet programs", icon: .iconForkKnife),
                .init(id: 5, stringId: "none", title: "None", icon: .iconX, isNone: true)
            ],
            type: .selection(isMultiple: true)
        ),
        
        // Testimonial
        .init(
            id: .testimonial,
            title: "Fit Senpai helped me lose 15% body fat!",
            subtitle: nil,
            options: [],
            type: .testimonial
        ),
        
        // Height & Weight
        .init(
            id: .measurements,
            title: "Height & Weight",
            subtitle: "This will be used to personalize your plan.",
            options: [],
            type: .heightWeight
        ),
        
        // Age
        .init(
            id: .age,
            title: "What's your age?",
            subtitle: "This will be used to personalize your plan.",
            options: [],
            type: .age
        ),
        
        // Main Goal
        .init(
            id: .mainGoal,
            title: "What is your main goal?",
            subtitle: "This will be used to personalize your plan.",
            options: [
                .init(id: 1, stringId: "fat_loss", title: "Fat loss"),
                .init(id: 2, stringId: "muscle_gain", title: "Muscle gain"),
                .init(id: 3, stringId: "general_fitness", title: "General fitness"),
                .init(id: 4, stringId: "increased_endurance", title: "Increased endurance"),
                .init(id: 5, stringId: "aesthetic", title: "Aesthetic")
            ],
            type: .selection(isMultiple: false)
        ),
        
        // Macro Breakdown
        .init(
            id: .macroBreakdown,
            title: "",
            subtitle: nil,
            options: [],
            type: .macro
        ),
        
        // Barriers
        .init(
            id: .barriers,
            title: "What's stopping you from living healthier?",
            subtitle: nil,
            options: [
                .init(id: 1, stringId: "lack_of_consistency", title: "Lack of consistency", icon: .iconChartDown),
                .init(id: 2, stringId: "unhealthy_eating", title: "Unhealthy eating habits", icon: .iconHamburger),
                .init(id: 3, stringId: "expense", title: "Fitness is too expensive", icon: .iconCurrency),
                .init(id: 4, stringId: "busy_schedule", title: "Busy schedule", icon: .iconCalendarX),
                .init(id: 5, stringId: "lack_of_direction", title: "Not sure where to start", icon: .iconSmiley)
            ],
            type: .selection(isMultiple: false)
        ),
        
        // Goals
        .init(
            id: .goals,
            title: "What would you like to accomplish?",
            subtitle: nil,
            options: [
                .init(id: 1, stringId: "motivation_consistency", title: "Stay motivated & consistent", icon: .iconChartUp),
                .init(id: 2, stringId: "healthier_lifestyle", title: "Eat and live healthier", icon: .iconCarrot),
                .init(id: 3, stringId: "budget_fitness", title: "Save money while getting fit", icon: .iconPiggy),
                .init(id: 4, stringId: "energy_mood", title: "Boost my energy and mood", icon: .iconSun),
                .init(id: 5, stringId: "body_image", title: "Feel better about my body", icon: .iconSparkle)
            ],
            type: .selection(isMultiple: false)
        ),
        
        // Save Money
        .init(
            id: .saveMoney,
            title: "Achieve goals without spending too much",
            subtitle: nil,
            options: [],
            type: .saveMoney
        ),
        
        // Workout Experience
        .init(
            id: .workoutExperience,
            title: "How experienced are you with working out?",
            subtitle: nil,
            options: [
                .init(id: 1, stringId: "beginner", title: "Beginner", subtitle: "I'm new to fitness", icon: .iconWalk),
                .init(id: 2, stringId: "intermediate", title: "Intermediate", subtitle: "I workout from time to time", icon: .iconBarbell),
                .init(id: 3, stringId: "advanced", title: "Advanced", subtitle: "I exercise regularly", icon: .iconLightning)
            ],
            type: .selection(isMultiple: false)
        ),
        
        // Workout Location
        .init(
            id: .workoutLocation,
            title: "Choose your workout\nlocation",
            subtitle: nil,
            options: [
                .init(id: 1, stringId: "home", title: "Home", subtitle: "No equipment needed", icon: .iconHouse),
                .init(id: 2, stringId: "gym", title: "Gym", subtitle: "Machine and free-weight exercises", icon: .iconBuilding),
                .init(id: 3, stringId: "mixed", title: "Mixed", subtitle: "Combination of home and gym", icon: .iconArrowsCounter)
            ],
            type: .selection(isMultiple: false)
        ),
        
        // Workout Days
        .init(
            id: .workoutDays,
            title: "Which days work best for your workouts?",
            subtitle: nil,
            options: [
                .init(id: 1, stringId: "sunday", title: "Sunday"),
                .init(id: 2, stringId: "monday", title: "Monday"),
                .init(id: 3, stringId: "tuesday", title: "Tuesday"),
                .init(id: 4, stringId: "wednesday", title: "Wednesday"),
                .init(id: 5, stringId: "thursday", title: "Thursday"),
                .init(id: 6, stringId: "friday", title: "Friday"),
                .init(id: 7, stringId: "saturday", title: "Saturday")
            ],
            type: .selection(isMultiple: true)
        ),
        
        // Workout Duration
        .init(
            id: .workoutDuration,
            title: "Choose duration for your workouts",
            subtitle: nil,
            options: [
                .init(id: 1, stringId: "15_mins", title: "15 mins"),
                .init(id: 2, stringId: "30_mins", title: "30 mins"),
                .init(id: 3, stringId: "45_mins", title: "45 mins"),
                .init(id: 4, stringId: "60_mins", title: "60 mins"),
                .init(id: 5, stringId: "60_plus_mins", title: "60+ mins")
            ],
            type: .selection(isMultiple: false)
        ),
        
        // Health Restrictions
        .init(
            id: .healthRestrictions,
            title: "Do you have any health concerns?",
            subtitle: nil,
            options: [
                .init(id: 1, stringId: "none", title: "None", icon: .iconX, isNone: true),
                .init(id: 2, stringId: "joint_pain", title: "Joint pain", icon: .iconBone),
                .init(id: 3, stringId: "back_issues", title: "Back issues", icon: .iconHike),
                .init(id: 4, stringId: "heart_condition", title: "Heart condition", icon: .iconHeartbeat),
                .init(id: 5, stringId: "other", title: "Other", icon: .iconDots, isOthers: true)
            ],
            type: .selection(isMultiple: true)
        ),
        .init(
            id: .healthRestrictionsInput,
            title: "Other health concerns",
            subtitle: "Separate multiple items with a comma",
            options: [],
            type: .input(previousStep: .healthRestrictions, placeholder: "Shoulder injury")
        ),
        
        // Diet
        .init(
            id: .diet,
            title: "Do you follow a specific diet?",
            subtitle: nil,
            options: [
                .init(id: 1, stringId: "none", title: "None", icon: .iconX, isNone: true),
                .init(id: 2, stringId: "high_protein_low_carb", title: "High protein, low carb", icon: .iconFish),
                .init(id: 3, stringId: "vegetarian", title: "Vegetarian", icon: .iconOrange),
                .init(id: 4, stringId: "vegan", title: "Vegan", icon: .iconPlant),
                .init(id: 5, stringId: "other", title: "Other", icon: .iconDots, isOthers: true)
            ],
            type: .selection(isMultiple: false)
        ),
        .init(
            id: .dietInput,
            title: "Other specific diet",
            subtitle: nil,
            options: [],
            type: .input(previousStep: .diet, placeholder: "Pescatarian")
        ),
        
        // Allergies
        .init(
            id: .allergies,
            title: "Do you have any food allergies?",
            subtitle: nil,
            options: [
                .init(id: 1, stringId: "none", title: "None", icon: .iconX, isNone: true),
                .init(id: 2, stringId: "nuts", title: "Nuts", icon: .iconNuts),
                .init(id: 3, stringId: "dairy", title: "Milk and dairy", icon: .iconCheese),
                .init(id: 4, stringId: "shellfish", title: "Shellfish", icon: .iconShrimp),
                .init(id: 5, stringId: "other", title: "Other", icon: .iconDots, isOthers: true)
            ],
            type: .selection(isMultiple: true)
        ),
        .init(
            id: .allergiesInput,
            title: "Other food allergies",
            subtitle: "Separate multiple items with a comma",
            options: [],
            type: .input(previousStep: .allergies, placeholder: "Shrimp")
        ),
     
        // Cooking Style
        .init(
            id: .cookingStyle,
            title: "What's your cooking style?",
            subtitle: nil,
            options: [
                .init(id: 1, stringId: "quick_easy", title: "Quick & easy", subtitle: "Under 15 mins, low effort", icon: .iconTimer),
                .init(id: 2, stringId: "enjoy_cooking", title: "I enjoy cooking", subtitle: "Okay with longer prep", icon: .iconCooking),
                .init(id: 3, stringId: "simple_meals", title: "Simple meals only", subtitle: "Few steps, basic ingredients", icon: .iconListNumber),
                .init(id: 4, stringId: "order_food", title: "Mostly order food", subtitle: "Rarely cook at home", icon: .iconCart)
            ],
            type: .selection(isMultiple: false)
        ),
        
        // Notifications
        .init(
            id: .notifications,
            title: "",
            subtitle: "",
            options: [],
            type: .notification
        ),
        
        // Enable Notifications
        .init(
            id: .enableNotifications,
            title: "",
            subtitle: "",
            options: [],
            type: .enableNnotification
        )
    ]
}

struct SelectionItem: Identifiable {
    let id: Int
    let stringId: String
    let title: String
    let subtitle: String?
    let icon: ImageResource?
    
    var isOthers: Bool
    var isNone: Bool
    
    init(id: Int, stringId: String, title: String, subtitle: String? = nil, icon: ImageResource? = nil, isOthers: Bool = false, isNone: Bool = false) {
        self.id = id
        self.stringId = stringId
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.isOthers = isOthers
        self.isNone = isNone
    }
}
