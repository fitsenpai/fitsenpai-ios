import Foundation

enum StepType {
    case selection(showsButton: Bool)
    case heightWeight
    case age
    case macro
    case testimonial
    case notification
    case input(previousStep: String)
}

struct OnboardingStep {
    let id: String
    let title: String
    let subtitle: String?
    let options: [SelectionItem]
    let type: StepType
    
    var showsButton: Bool {
        if case .selection(let showsButton) = type {
            return showsButton
        }
        return true
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
    
    static let steps: [OnboardingStep] = [
        // Gender Selection
        .init(
            id: "gender",
            title: "Choose your gender",
            subtitle: "This will be used to personalize your plan.",
            options: [
                .init(id: "male", title: "Male", icon: "male"),
                .init(id: "female", title: "Female", icon: "female"),
                .init(id: "other", title: "Other", icon: "other")
            ],
            type: .selection(showsButton: false)
        ),
        
        // Daily Activity Level
        .init(
            id: "activity_level",
            title: "How active are you daily?",
            subtitle: nil,
            options: [
                .init(id: "sedentary", title: "Sedentary", subtitle: "Mostly sitting, little exercise", icon: "sedentary"),
                .init(id: "light", title: "Light activity", subtitle: "1-2 exercises/week", icon: "light"),
                .init(id: "moderate", title: "Moderate", subtitle: "3-5 exercises/week", icon: "moderate"),
                .init(id: "heavy", title: "Heavy training", subtitle: "6-7 exercises/week", icon: "heavy"),
                .init(id: "athlete", title: "Athlete", subtitle: "Training 2x per day", icon: "athlete")
            ],
            type: .selection(showsButton: false)
        ),
        
        // Past Training Experience
        .init(
            id: "past_training",
            title: "Which of these have you tried in the past?",
            subtitle: nil,
            options: [
                .init(id: "trainers", title: "Personal trainers", icon: "trainers"),
                .init(id: "apps", title: "Fitness apps", icon: "apps"),
                .init(id: "videos", title: "Workout videos", icon: "videos"),
                .init(id: "meal_plans", title: "Meal plans or diet programs", icon: "meal"),
                .init(id: "none", title: "None", icon: "xmark")
            ],
            type: .selection(showsButton: true)
        ),
        
        // Testimonial
        .init(
            id: "testimonial",
            title: "Fit Senpai helped me lose 15% body fat!",
            subtitle: "I started in 2023 and have already lost 15% body fat! I didn't need to hire a trainer or spend all day figuring out what to eat.\n\n- Corina V.",
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
                .init(id: "fat_loss", title: "Fat loss", icon: "fat_loss"),
                .init(id: "muscle_gain", title: "Muscle gain", icon: "muscle"),
                .init(id: "general_fitness", title: "General fitness", icon: "fitness"),
                .init(id: "endurance", title: "Increased endurance", icon: "endurance"),
                .init(id: "aesthetic", title: "Aesthetic", icon: "aesthetic")
            ],
            type: .selection(showsButton: false)
        ),
        
        // Macro Breakdown
        .init(
            id: "macro_breakdown",
            title: "Your personalized macro breakdown",
            subtitle: "Based on your profile, here's what your body needs to reach your goal",
            options: [],
            type: .macro
        ),
        
        // Barriers
        .init(
            id: "barriers",
            title: "What's stopping you from living healthier?",
            subtitle: nil,
            options: [
                .init(id: "consistency", title: "Lack of consistency", icon: "consistency"),
                .init(id: "eating", title: "Unhealthy eating habits", icon: "eating"),
                .init(id: "expensive", title: "Fitness is too expensive", icon: "money"),
                .init(id: "schedule", title: "Busy schedule", icon: "schedule"),
                .init(id: "unsure", title: "Not sure where to start", icon: "question")
            ],
            type: .selection(showsButton: false)
        ),
        
        // Goals
        .init(
            id: "goals",
            title: "What would you like to accomplish?",
            subtitle: nil,
            options: [
                .init(id: "motivated", title: "Stay motivated and consistent", icon: "motivation"),
                .init(id: "healthy", title: "Eat and live healthier", icon: "healthy"),
                .init(id: "save", title: "Save money while getting fit", icon: "savings"),
                .init(id: "energy", title: "Boost my energy and mood", icon: "energy"),
                .init(id: "confidence", title: "Feel better about my body", icon: "confidence")
            ],
            type: .selection(showsButton: false)
        ),
        
        // Save Money
        .init(
            id: "save_money",
            title: "Achieve goals without spending too much",
            subtitle: "Why pay more for the same results?\nFit Senpai users save up to 90% compared to traditional fitness programs",
            options: [],
            type: .selection(showsButton: true)
        ),
        
        // Workout Experience
        .init(
            id: "workout_experience",
            title: "How experienced are you with working out?",
            subtitle: nil,
            options: [
                .init(id: "beginner", title: "Beginner", subtitle: "I'm new to fitness", icon: "beginner"),
                .init(id: "intermediate", title: "Intermediate", subtitle: "I workout from time to time", icon: "intermediate"),
                .init(id: "advanced", title: "Advanced", subtitle: "I exercise regularly", icon: "advanced")
            ],
            type: .selection(showsButton: false)
        ),
        
        // Workout Location
        .init(
            id: "workout_location",
            title: "Choose your workout location",
            subtitle: nil,
            options: [
                .init(id: "home", title: "Home", subtitle: "No equipment needed", icon: "home"),
                .init(id: "gym", title: "Gym", subtitle: "Have access to the weight room & exercises", icon: "gym"),
                .init(id: "mixed", title: "Mixed", subtitle: "Combination of home and gym workouts", icon: "mixed")
            ],
            type: .selection(showsButton: false)
        ),
        
        // Workout Days
        .init(
            id: "workout_days",
            title: "Which days work best for your workouts?",
            subtitle: nil,
            options: [
                .init(id: "sunday", title: "Sunday", icon: "calendar"),
                .init(id: "monday", title: "Monday", icon: "calendar"),
                .init(id: "tuesday", title: "Tuesday", icon: "calendar"),
                .init(id: "wednesday", title: "Wednesday", icon: "calendar"),
                .init(id: "thursday", title: "Thursday", icon: "calendar"),
                .init(id: "friday", title: "Friday", icon: "calendar"),
                .init(id: "saturday", title: "Saturday", icon: "calendar")
            ],
            type: .selection(showsButton: true)
        ),
        
        // Workout Duration
        .init(
            id: "workout_duration",
            title: "Choose duration for your workouts",
            subtitle: nil,
            options: [
                .init(id: "15", title: "15 mins", icon: "clock"),
                .init(id: "30", title: "30 mins", icon: "clock"),
                .init(id: "45", title: "45 mins", icon: "clock"),
                .init(id: "60", title: "60 mins", icon: "clock")
            ],
            type: .selection(showsButton: false)
        ),
        
        // Health Restrictions
        .init(
            id: "health_restrictions",
            title: "Do you have any health concerns?",
            subtitle: nil,
            options: [
                .init(id: "none", title: "None", icon: "xmark"),
                .init(id: "joint_pain", title: "Joint pain", icon: "joint"),
                .init(id: "back_issues", title: "Back issues", icon: "back"),
                .init(id: "heart_condition", title: "Heart condition", icon: "heart"),
                .init(id: "other", title: "Other", icon: "dots")
            ],
            type: .selection(showsButton: true)
        ),
        
        // Diet Preferences
        .init(
            id: "diet",
            title: "Do you follow a specific diet?",
            subtitle: nil,
            options: [
                .init(id: "none", title: "None", icon: "xmark"),
                .init(id: "high_protein", title: "High protein, low carb", icon: "protein"),
                .init(id: "vegetarian", title: "Vegetarian", icon: "vegetable"),
                .init(id: "vegan", title: "Vegan", icon: "vegan"),
                .init(id: "other", title: "Other", icon: "dots")
            ],
            type: .selection(showsButton: true)
        ),
        
        // Food Allergies
        .init(
            id: "allergies",
            title: "Do you have any food allergies?",
            subtitle: nil,
            options: [
                .init(id: "none", title: "None", icon: "xmark"),
                .init(id: "nuts", title: "Nuts", icon: "nuts"),
                .init(id: "dairy", title: "Milk and dairy", icon: "dairy"),
                .init(id: "shellfish", title: "Shellfish", icon: "shellfish"),
                .init(id: "other", title: "Other", icon: "dots")
            ],
            type: .selection(showsButton: true)
        ),
        
        // Eating Habits
        .init(
            id: "eating_habits",
            title: "What best describes your eating habits?",
            subtitle: nil,
            options: [
                .init(id: "cook", title: "I cook most of my meals", icon: "cook"),
                .init(id: "meal_plan", title: "I order meal plans", icon: "meal"),
                .init(id: "eat_out", title: "I eat out often", icon: "restaurant"),
                .init(id: "mix", title: "I mix between cooking and ordering", icon: "mix")
            ],
            type: .selection(showsButton: false)
        ),
        
        // Notifications
        .init(
            id: "notifications",
            title: "Reach your goals with notifications",
            subtitle: "We'll always keep your information private and secure",
            options: [],
            type: .notification
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
