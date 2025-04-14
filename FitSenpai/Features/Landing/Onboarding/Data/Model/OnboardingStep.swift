import Foundation

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
                .init(id: 1, stringId: "M", title: "Male", icon: "ic_male"),
                .init(id: 2, stringId: "F", title: "Female", icon: "ic_female"),
                .init(id: 3, stringId: "O", title: "Other", icon: "ic_dots")
            ],
            type: .selection(isMultiple: false)
        ),
        
        // Daily Activity Level
        .init(
            id: .activityLevel,
            title: "How active are you daily?",
            subtitle: nil,
            options: [
                .init(id: 1, stringId: "sedentary", title: "Sedentary", subtitle: "Mostly sitting, little exercise", icon: "ic_chair"),
                .init(id: 2, stringId: "light", title: "Light activity", subtitle: "1-2 exercises/week", icon: "ic_jog"),
                .init(id: 3, stringId: "moderate", title: "Moderate", subtitle: "3-5 exercises/week", icon: "ic_bike"),
                .init(id: 4, stringId: "heavy", title: "Heavy training", subtitle: "6-7 exercises/week", icon: "ic_dumble"),
                .init(id: 5, stringId: "athlete", title: "Athlete", subtitle: "Training 2x per day", icon: "ic_swim")
            ],
            type: .selection(isMultiple: false)
        ),
        
        // Past Training Experience
        .init(
            id: .pastTraining,
            title: "Which of these have you tried in the past?",
            subtitle: nil,
            options: [
                .init(id: 1, stringId: "personal_trainers", title: "Personal trainers", icon: "ic_handshake"),
                .init(id: 2, stringId: "fitness_apps", title: "Fitness apps", icon: "ic_phone"),
                .init(id: 3, stringId: "workout_videos", title: "Workout videos", icon: "ic_play_workout"),
                .init(id: 4, stringId: "meal_plans", title: "Meal plans or diet programs", icon: "ic_spoon_fork"),
                .init(id: 5, stringId: "none", title: "None", icon: "ic_x", isNone: true)
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
                .init(id: 4, stringId: "endurance", title: "Increased endurance"),
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
                .init(id: 1, stringId: "consistency", title: "Lack of consistency", icon: "ic_line_chart_down"),
                .init(id: 2, stringId: "eating_habits", title: "Unhealthy eating habits", icon: "ic_burger"),
                .init(id: 3, stringId: "expensive", title: "Fitness is too expensive", icon: "ic_currency"),
                .init(id: 4, stringId: "busy", title: "Busy schedule", icon: "ic_calendar_x"),
                .init(id: 5, stringId: "unsure", title: "Not sure where to start", icon: "ic_smiley_melting")
            ],
            type: .selection(isMultiple: false)
        ),
        
        // Goals
        .init(
            id: .goals,
            title: "What would you like to accomplish?",
            subtitle: nil,
            options: [
                .init(id: 1, stringId: "motivation", title: "Stay motivated and consistent", icon: "ic_line_chart"),
                .init(id: 2, stringId: "healthy_living", title: "Eat and live healthier", icon: "ic_carrot"),
                .init(id: 3, stringId: "save_money", title: "Save money while getting fit", icon: "ic_piggy"),
                .init(id: 4, stringId: "energy", title: "Boost my energy and mood", icon: "ic_sun"),
                .init(id: 5, stringId: "confidence", title: "Feel better about my body", icon: "ic_sparkle")
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
                .init(id: 1, stringId: "beginner", title: "Beginner", subtitle: "I'm new to fitness", icon: "ic_jog"),
                .init(id: 2, stringId: "intermediate", title: "Intermediate", subtitle: "I workout from time to time", icon: "ic_dumble"),
                .init(id: 3, stringId: "advanced", title: "Advanced", subtitle: "I exercise regularly", icon: "ic_lightning")
            ],
            type: .selection(isMultiple: false)
        ),
        
        // Workout Location
        .init(
            id: .workoutLocation,
            title: "Choose your workout\nlocation",
            subtitle: nil,
            options: [
                .init(id: 1, stringId: "home", title: "Home", subtitle: "No equipment needed", icon: "ic_house"),
                .init(id: 2, stringId: "gym", title: "Gym", subtitle: "Machine and free-weight exercises", icon: "ic_building"),
                .init(id: 3, stringId: "mixed", title: "Mixed", subtitle: "Combination of home and gym workouts", icon: "ic_arrows")
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
                .init(id: 1, stringId: "15mins", title: "15 mins"),
                .init(id: 2, stringId: "30mins", title: "30 mins"),
                .init(id: 3, stringId: "45mins", title: "45 mins"),
                .init(id: 4, stringId: "60mins", title: "60 mins"),
                .init(id: 5, stringId: "60plus", title: "60+ mins")
            ],
            type: .selection(isMultiple: false)
        ),
        
        // Health Restrictions
        .init(
            id: .healthRestrictions,
            title: "Do you have any health concerns?",
            subtitle: nil,
            options: [
                .init(id: 1, stringId: "none", title: "None", icon: "ic_x", isNone: true),
                .init(id: 2, stringId: "joint_pain", title: "Joint pain", icon: "ic_bone_whole"),
                .init(id: 3, stringId: "back_issues", title: "Back issues", icon: "ic_hike"),
                .init(id: 4, stringId: "heart_condition", title: "Heart condition", icon: "ic_heart_2"),
                .init(id: 5, stringId: "other", title: "Other", icon: "ic_dots", isOthers: true)
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
                .init(id: 1, stringId: "none", title: "None", icon: "ic_x", isNone: true),
                .init(id: 2, stringId: "low_carb", title: "High protein, low carb", icon: "ic_fish"),
                .init(id: 3, stringId: "vegetarian", title: "Vegetarian", icon: "ic_orange"),
                .init(id: 4, stringId: "vegan", title: "Vegan", icon: "ic_leaves"),
                .init(id: 5, stringId: "other", title: "Other", icon: "ic_dots", isOthers: true)
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
                .init(id: 1, stringId: "none", title: "None", icon: "ic_x", isNone: true),
                .init(id: 2, stringId: "nuts", title: "Nuts", icon: "ic_nuts"),
                .init(id: 3, stringId: "dairy", title: "Milk and dairy", icon: "ic_cheese"),
                .init(id: 4, stringId: "shellfish", title: "Shellfish", icon: "ic_shrimp"),
                .init(id: 5, stringId: "other", title: "Other", icon: "ic_dots", isOthers: true)
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
                .init(id: 1, stringId: "quick", title: "Quick & easy", subtitle: "Under 15 mins, low effort", icon: "icon_timer"),
                .init(id: 2, stringId: "enjoy_cooking", title: "I enjoy cooking", subtitle: "Okay with longer prep", icon: "icon_cooking"),
                .init(id: 3, stringId: "simple", title: "Simple meals only", subtitle: "Few steps, basic ingredients", icon: "icon_list_number"),
                .init(id: 4, stringId: "order_food", title: "Mostly order food", subtitle: "Rarely cook at home", icon: "icon_cart")
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
    let icon: String?
    
    var isOthers: Bool
    var isNone: Bool
    
    init(id: Int, stringId: String, title: String, subtitle: String? = nil, icon: String? = nil, isOthers: Bool = false, isNone: Bool = false) {
        self.id = id
        self.stringId = stringId
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.isOthers = isOthers
        self.isNone = isNone
    }
}
