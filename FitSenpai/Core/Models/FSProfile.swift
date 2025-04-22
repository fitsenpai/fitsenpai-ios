import Foundation

struct FSProfile {
    var gender: Gender?
    var activityLevel: ActivityLevel?
    var mainGoal: FitnessGoals?
    var height: Double?
    var weight: Double?
    var age: Int
    var workoutExperience: WorkoutExperience?
    var workoutLocation: WorkoutLocation?
    var workoutDays: [WeekDay]
    var workoutDuration: WorkoutDuration?
    var healthRestrictions: [HealthConcern]
    var otherHealthRestrictions: String?
    var diet: DietaryPreference?
    var otherDiet: String?
    var allergies: [Allergy]
    var otherAllergies: String?
    var cookingStyle: CookingStyle?
    var pastTrainings: [PastTraining]
    var barriers: Barriers?
    var goals: Goals?
    var isMetric: Bool

    init(gender: Gender? = nil,
         activityLevel: ActivityLevel? = nil,
         mainGoal: FitnessGoals? = nil,
         height: Double? = nil,
         weight: Double? = nil,
         age: Int? = nil,
         workoutExperience: WorkoutExperience? = nil,
         workoutLocation: WorkoutLocation? = nil,
         workoutDays: [WeekDay] = [],
         workoutDuration: WorkoutDuration? = nil,
         healthRestrictions: [HealthConcern] = [],
         otherHealthRestrictions: String? = nil,
         diet: DietaryPreference? = nil,
         otherDiet: String? = nil,
         allergies: [Allergy] = [],
         otherAllergies: String? = nil,
         cookingStyle: CookingStyle? = nil,
         pastTrainings: [PastTraining] = [],
         barriers: Barriers? = nil,
         goals: Goals? = nil,
         isMetric: Bool = false) {
        self.gender = gender
        self.activityLevel = activityLevel
        self.mainGoal = mainGoal
        self.height = height
        self.weight = weight
        self.age = age ?? 0
        self.workoutExperience = workoutExperience
        self.workoutLocation = workoutLocation
        self.workoutDays = workoutDays
        self.workoutDuration = workoutDuration
        self.healthRestrictions = healthRestrictions
        self.otherHealthRestrictions = otherHealthRestrictions
        self.diet = diet
        self.otherDiet = otherDiet
        self.allergies = allergies
        self.otherAllergies = otherAllergies
        self.cookingStyle = cookingStyle
        self.pastTrainings = pastTrainings
        self.barriers = barriers
        self.goals = goals
        self.isMetric = isMetric
    }
    
    func toEntity() -> FSProfileEntity {
        return FSProfileEntity(
            gender: gender?.intValue,
            activityLevel: activityLevel?.intValue,
            mainGoal: mainGoal?.intValue,
            height: height,
            weight: weight,
            age: age,
            workoutExperience: workoutExperience?.intValue,
            workoutLocation: workoutLocation?.intValue,
            workoutDays: workoutDays.map { $0.intValue },
            workoutDuration: workoutDuration?.intValue,
            healthRestrictions: healthRestrictions.map { $0.intValue },
            otherHealthRestrictions: otherHealthRestrictions,
            diet: diet?.intValue,
            otherDiet: otherDiet,
            allergies: allergies.map { $0.intValue },
            otherAllergies: otherAllergies,
            cookingStyle: cookingStyle?.intValue,
            pastTrainings: pastTrainings.map { $0.intValue },
            barriers: barriers?.intValue,
            goals: goals?.intValue,
            isMetric: isMetric
        )
    }

    // IMPROVE: Structured logging
    func printLogs() {
        var log = ["=== Onboarding Selections ===\n"]
        
        // Profile data
        if let gender {
            log.append("Gender: \(gender.title)")
        }
        
        if let activityLevel {
            log.append("Activity Level: \(activityLevel.title)")
        }
        
        if let mainGoal = mainGoal {
            log.append("Main Goal: \(mainGoal.title)")
        }
        
        // Measurements
        log.append("\nMeasurements:")
        
        if let height  {
            log.append("Height: \(height) \(isMetric ? "cm" : "inches")")
        }
        
        if let weight  {
            log.append("Weight: \(weight) \(isMetric ? "kg" : "lbs")")
        }
        
        log.append("Age: \(age)")
        
        // Workout preferences
        log.append("\nWorkout Preferences:")
        
        if let workoutExperience {
            log.append("Experience Level: \(workoutExperience.title)")
        }
        
        if let workoutLocation {
            log.append("Location: \(workoutLocation.title)")
        }
        
        log.append("Days: \(workoutDays.map({ $0.shortName }).joined(separator: ", "))")
        
        if let workoutDuration {
            log.append("Duration: \(workoutDuration.title)")
        }
        
        // Health and diet
        log.append("\nHealth & Diet:")
        
        if !healthRestrictions.isEmpty {
            log.append("Health Restrictions: \(healthRestrictions.map({ $0.title }).joined(separator: ", "))")
        }
        
        if let otherHealthRestrictions {
            log.append("Other Health Restrictions: \(otherHealthRestrictions)")
        }
        
        if let diet {
            log.append("Diet: \(diet.title)")
        }
        
        if let otherDiet {
            log.append("Other Diet: \(otherDiet)")
        }
        
        if !allergies.isEmpty {
            log.append("Allergies: \(allergies.map({ $0.title }).joined(separator: ", "))")
        }
        
        if let otherAllergies {
            log.append("Other Allergies: \(otherAllergies)")
        }
        
        if let cookingStyle {
            log.append("Cooking Style: \(cookingStyle.title)")
        }
        
        // Additional info
        log.append("\nAdditional Information:")
        
        if !pastTrainings.isEmpty {
            log.append("Past Training Methods: \(pastTrainings.map({ $0.title }).joined(separator: ", "))")
        }
        
        if let barriers {
            log.append("Barriers: \(barriers.title)")
        }
        
        if let goals {
            log.append("Goals: \(goals.title)")
        }
        
        log.append("\n=== End of Selections ===")
        
        print(log.joined(separator: "\n"))
    }
}
