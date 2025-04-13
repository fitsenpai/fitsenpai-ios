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
    case input(previousStep: String, placeholder: String)
}

struct OnboardingStep {
    let id: String
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
            case "past_training", "measurements", "age", "workout_days",
                 "health_restrictions", "allergies", "health_restrictions_input",
                 "diet_input", "allergies_input", "diet":
                return "Next"
            default:
                return "Continue"
        }
    }
    
    static let steps: [OnboardingStep] = [
        // Gender Selection
        .init(
            id: "gender",
            title: "Choose your gender",
            subtitle: "This will be used to personalize your plan.",
            options: [
                .init(id: "male", title: "Male", icon: "ic_male"),
                .init(id: "female", title: "Female", icon: "ic_female"),
                .init(id: "other", title: "Other", icon: "ic_dots")
            ],
            type: .selection(isMultiple: false)
        ),
        
        // Daily Activity Level
        .init(
            id: "activity_level",
            title: "How active are you daily?",
            subtitle: nil,
            options: [
                .init(id: "sedentary", title: "Sedentary", subtitle: "Mostly sitting, little exercise", icon: "ic_chair"),
                .init(id: "light", title: "Light activity", subtitle: "1-2 exercises/week", icon: "ic_jog"),
                .init(id: "moderate", title: "Moderate", subtitle: "3-5 exercises/week", icon: "ic_bike"),
                .init(id: "heavy", title: "Heavy training", subtitle: "6-7 exercises/week", icon: "ic_dumble"),
                .init(id: "athlete", title: "Athlete", subtitle: "Training 2x per day", icon: "ic_swim")
            ],
            type: .selection(isMultiple: false)
        ),
        
        // Past Training Experience
        .init(
            id: "past_training",
            title: "Which of these have you tried in the past?",
            subtitle: nil,
            options: [
                .init(id: "trainers", title: "Personal trainers", icon: "ic_handshake"),
                .init(id: "apps", title: "Fitness apps", icon: "ic_phone"),
                .init(id: "videos", title: "Workout videos", icon: "ic_play_workout"),
                .init(id: "meal_plans", title: "Meal plans or diet programs", icon: "ic_spoon_fork"),
                .init(id: "none", title: "None", icon: "ic_x")
            ],
            type: .selection(isMultiple: true)
        ),
        
        // Testimonial
        .init(
            id: "testimonial",
            title: "Fit Senpai helped me lose 15% body fat!",
            subtitle: nil,
            options: [],
            type: .testimonial
        ),
        
        // Height & Weight
        .init(
            id: "measurements",
            title: "Height & Weight",
            subtitle: "This will be used to personalize your plan.",
            options: [],
            type: .heightWeight
        ),
        
        // Age
        .init(
            id: "age",
            title: "What's your age?",
            subtitle: "This will be used to personalize your plan.",
            options: [],
            type: .age
        ),
        
        // Main Goal
        .init(
            id: "main_goal",
            title: "What is your main goal?",
            subtitle: "This will be used to personalize your plan.",
            options: [
                .init(id: "fat_loss", title: "Fat loss"),
                .init(id: "muscle_gain", title: "Muscle gain"),
                .init(id: "general_fitness", title: "General fitness"),
                .init(id: "endurance", title: "Increased endurance"),
                .init(id: "aesthetic", title: "Aesthetic")
            ],
            type: .selection(isMultiple: false)
        ),
        
        // Macro Breakdown
        .init(
            id: "macro_breakdown",
            title: "",
            subtitle: nil,
            options: [],
            type: .macro
        ),
        
        // Barriers
        .init(
            id: "barriers",
            title: "What's stopping you from living healthier?",
            subtitle: nil,
            options: [
                .init(id: "consistency", title: "Lack of consistency", icon: "ic_line_chart_down"),
                .init(id: "eating", title: "Unhealthy eating habits", icon: "ic_burger"),
                .init(id: "expensive", title: "Fitness is too expensive", icon: "ic_currency"),
                .init(id: "schedule", title: "Busy schedule", icon: "ic_calendar_x"),
                .init(id: "unsure", title: "Not sure where to start", icon: "ic_smiley_melting")
            ],
            type: .selection(isMultiple: false)
        ),
        
        // Goals
        .init(
            id: "goals",
            title: "What would you like to accomplish?",
            subtitle: nil,
            options: [
                .init(id: "motivated", title: "Stay motivated and consistent", icon: "ic_line_chart"),
                .init(id: "healthy", title: "Eat and live healthier", icon: "ic_carrot"),
                .init(id: "save", title: "Save money while getting fit", icon: "ic_piggy"),
                .init(id: "energy", title: "Boost my energy and mood", icon: "ic_sun"),
                .init(id: "confidence", title: "Feel better about my body", icon: "ic_sparkle")
            ],
            type: .selection(isMultiple: false)
        ),
        
        // Save Money
        .init(
            id: "save_money",
            title: "Achieve goals without spending too much",
            subtitle: nil,
            options: [],
            type: .saveMoney
        ),
        
        // Workout Experience
        .init(
            id: "workout_experience",
            title: "How experienced are you with working out?",
            subtitle: nil,
            options: [
                .init(id: "beginner", title: "Beginner", subtitle: "I'm new to fitness", icon: "ic_jog"),
                .init(id: "intermediate", title: "Intermediate", subtitle: "I workout from time to time", icon: "ic_dumble"),
                .init(id: "advanced", title: "Advanced", subtitle: "I exercise regularly", icon: "ic_lightning")
            ],
            type: .selection(isMultiple: false)
        ),
        
        // Workout Location
        .init(
            id: "workout_location",
            title: "Choose your workout\nlocation",
            subtitle: nil,
            options: [
                .init(id: "home", title: "Home", subtitle: "No equipment needed", icon: "ic_house"),
                .init(id: "gym", title: "Gym", subtitle: "Machine and free-weight exercises", icon: "ic_building"),
                .init(id: "mixed", title: "Mixed", subtitle: "Combination of home and gym workouts", icon: "ic_arrows")
            ],
            type: .selection(isMultiple: false)
        ),
        
        // Workout Days
        .init(
            id: "workout_days",
            title: "Which days work best for your workouts?",
            subtitle: nil,
            options: [
                .init(id: "sunday", title: "Sunday"),
                .init(id: "monday", title: "Monday"),
                .init(id: "tuesday", title: "Tuesday"),
                .init(id: "wednesday", title: "Wednesday"),
                .init(id: "thursday", title: "Thursday"),
                .init(id: "friday", title: "Friday"),
                .init(id: "saturday", title: "Saturday")
            ],
            type: .selection(isMultiple: true)
        ),
        
        // Workout Duration
        .init(
            id: "workout_duration",
            title: "Choose duration for your workouts",
            subtitle: nil,
            options: [
                .init(id: "15", title: "15 mins"),
                .init(id: "30", title: "30 mins"),
                .init(id: "45", title: "45 mins"),
                .init(id: "60", title: "60 mins"),
                .init(id: "60+", title: "60+ mins")
            ],
            type: .selection(isMultiple: false)
        ),
        
        // Health Restrictions
        .init(
            id: "health_restrictions",
            title: "Do you have any health concerns?",
            subtitle: nil,
            options: [
                .init(id: "none", title: "None", icon: "ic_x"),
                .init(id: "joint_pain", title: "Joint pain", icon: "ic_bone"),
                .init(id: "back_issues", title: "Back issues", icon: "ic_hike"),
                .init(id: "heart_condition", title: "Heart condition", icon: "ic_heart_2"),
                .init(id: "other", title: "Other", icon: "ic_dots")
            ],
            type: .selection(isMultiple: true)
        ),
        .init(
            id: "health_restrictions_input",
            title: "Other health concerns",
            subtitle: "Separate multiple items with a comma",
            options: [],
            type: .input(previousStep: "health_restrictions", placeholder: "Shoulder injury")
        ),
        
        // Diet and its input
        .init(
            id: "diet",
            title: "Do you follow a specific diet?",
            subtitle: nil,
            options: [
                .init(id: "none", title: "None", icon: "ic_x"),
                .init(id: "high_protein", title: "High protein, low carb", icon: "ic_fish"),
                .init(id: "vegetarian", title: "Vegetarian", icon: "ic_orange"),
                .init(id: "vegan", title: "Vegan", icon: "ic_leaves"),
                .init(id: "other", title: "Other", icon: "ic_dots")
            ],
            type: .selection(isMultiple: false)
        ),
        .init(
            id: "diet_input",
            title: "Other specific diet",
            subtitle: nil,
            options: [],
            type: .input(previousStep: "diet", placeholder: "Pescatarian")
        ),
        
        // Allergies and its input
        .init(
            id: "allergies",
            title: "Do you have any food allergies?",
            subtitle: nil,
            options: [
                .init(id: "none", title: "None", icon: "ic_x"),
                .init(id: "nuts", title: "Nuts", icon: "ic_nuts"),
                .init(id: "dairy", title: "Milk and dairy", icon: "ic_cheese"),
                .init(id: "shellfish", title: "Shellfish", icon: "ic_shrimp"),
                .init(id: "other", title: "Other", icon: "ic_dots")
            ],
            type: .selection(isMultiple: true)
        ),
        .init(
            id: "allergies_input",
            title: "Other food allergies",
            subtitle: "Separate multiple items with a comma",
            options: [],
            type: .input(previousStep: "allergies", placeholder: "Shrimp")
        ),
     
        // Cooking Style
        .init(
            id: "cooking_style",
            title: "What’s your cooking style?",
            subtitle: nil,
            options: [
                .init(id: "quick", title: "Quick & easy", subtitle: "Under 15 mins, low effort",  icon: "icon_timer"),
                .init(id: "cooking", title: "I enjoy cooking", subtitle: "Okay with longer prep", icon: "icon_cooking"),
                .init(id: "outside", title: "Simple meals only", subtitle: "Few steps, basic ingredients", icon: "icon_list_number"),
                .init(id: "mixed", title: "Mostly order food", subtitle: "Rarely cook at home", icon: "icon_cart")
            ],
            type: .selection(isMultiple: false)
        ),
        
        // Notifications
        .init(
            id: "notifications",
            title: "",
            subtitle: "",
            options: [],
            type: .notification
        ),
        
        // Enable Notifications
        .init(
            id: "enable_notifications",
            title: "",
            subtitle: "",
            options: [],
            type: .enableNnotification
        )
    ]
}

struct SelectionItem: Identifiable {
    let id: String
    let title: String
    let subtitle: String?
    let icon: String?
    
    init(id: String, title: String, subtitle: String? = nil, icon: String? = nil) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
    }
}
