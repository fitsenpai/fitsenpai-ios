import Foundation
import Combine
import SwiftData

@MainActor
class SettingsViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var firstName: String = "Bella"
    @Published var lastName: String = "Oakley"
    @Published var profile: FitnessProfile
    @Published var viewState: ViewState = .idle
    @Published var activeSheet: FeedbackType?
    @Published var activePopup: SettingsPopup?
    @Published var isPresentedManageSubscription: Bool = false
    
    // MARK: - Private Properties
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Use Cases
    @Inject private var singoutUseCase: SignOutUseCaseProtocol
    
    // MARK: - Init
    init(profile: FitnessProfile? = nil) {
        self.profile = profile ?? FitnessProfile()
    }
    
}

// MARK: Computed properties
extension SettingsViewModel {
    
    var fullname: String {
        "\(firstName) \(lastName)"
    }
    
    var displayDietaryPreference: String {
        guard let diet = profile.diet, diet != .none else {
            return "None"
        }
        if diet == .other, let customDiet = profile.otherDiet, !customDiet.isEmpty {
            return customDiet
        }
        return diet.title
    }
    
    var displayAllergies: String {
        if profile.allergies.isEmpty {
            return "None"
        }
        
        var display = profile.allergies
            .filter { $0 != .other }
            .map { $0.rawValue }
        
        if profile.allergies.contains(.other), let customAllergy = profile.otherAllergies, !customAllergy.isEmpty {
            display.append(customAllergy)
        }
        
        return display.joined(separator: ", ")
    }
    
    var displayHealthConcerns: String {
        if profile.healthRestrictions.isEmpty {
            return "None"
        }
        
        var display = profile.healthRestrictions
            .filter { $0 != .other }
            .map { $0.rawValue }
        
        if profile.healthRestrictions.contains(.other), let customHealth = profile.otherHealthRestrictions, !customHealth.isEmpty {
            display.append(customHealth)
        }
        
        return display.joined(separator: ", ")
    }
    
    var formattedHeightWeight: String {
        if profile.isMetric {
            return String(format: "%.0f cm, %.0f kg", profile.height ?? 0, profile.weight ?? 0)
        } else {
            let feet = Int(floor((profile.height ?? 0) / 30.48))
            let inches = Int(((profile.height ?? 0).truncatingRemainder(dividingBy: 30.48) / 2.54).rounded())
            let pounds = Int((profile.weight ?? 0) * 2.20462)
            return String(format: "%d'%d\", %d lb", feet, inches, pounds)
        }
    }
}

// MARK: Update functions
extension SettingsViewModel {
    private func saveProfile(modelContext: ModelContext) {
        FitnessProfileEntity.save(profile, context: modelContext)
    }

    func updateGender(_ gender: Gender?, modelContext: ModelContext) async {
        profile.gender = gender
        saveProfile(modelContext: modelContext)
    }
    
    func updateActivityLevel(_ level: ActivityLevel?, modelContext: ModelContext) async {
        profile.activityLevel = level
        saveProfile(modelContext: modelContext)
    }
    
    func updateFitnessGoal(_ goal: FitnessGoals?, modelContext: ModelContext) async {
        profile.mainGoal = goal
        saveProfile(modelContext: modelContext)
    }
    
    func updateWorkoutLocation(_ location: WorkoutLocation?, modelContext: ModelContext) async {
        profile.workoutLocation = location
        saveProfile(modelContext: modelContext)
    }
    
    func updateWorkoutDays(_ days: [WeekDay], modelContext: ModelContext) async {
        profile.workoutDays = days
        saveProfile(modelContext: modelContext)
    }
    
    func updateWorkoutDuration(_ duration: WorkoutDuration?, modelContext: ModelContext) async {
        profile.workoutDuration = duration
        saveProfile(modelContext: modelContext)
    }
    
    func updateDietaryPreference(_ preference: DietaryPreference?, customValue: String = "", modelContext: ModelContext) async {
        profile.diet = preference
        profile.otherDiet = preference == .other ? customValue : nil
        saveProfile(modelContext: modelContext)
    }
    
    func updateExerciseDifficulty(_ level: WorkoutExperience?, modelContext: ModelContext) async {
        profile.workoutExperience = level
        saveProfile(modelContext: modelContext)
    }
    
    func updateAllergies(_ allergies: [Allergy], customValue: String = "", modelContext: ModelContext) async {
        profile.allergies = allergies
        profile.otherAllergies = allergies.contains(.other) ? customValue : nil
        saveProfile(modelContext: modelContext)
    }
    
    func updateHealthConcerns(_ concerns: [HealthConcern], customValue: String = "", modelContext: ModelContext) async {
        profile.healthRestrictions = concerns
        profile.otherHealthRestrictions = concerns.contains(.other) ? customValue : nil
        saveProfile(modelContext: modelContext)
    }
    
    func updateHeightWeight(height: Double, weight: Double, isMetric: Bool, modelContext: ModelContext) async {
        profile.height = height
        profile.weight = weight
        profile.isMetric = isMetric
        saveProfile(modelContext: modelContext)
    }
    
    func updateName(firstName: String, lastName: String) async {
        self.firstName = firstName
        self.lastName = lastName
        // TODO: Implement API call to update name
    }
    
    func updateAge(_ newAge: Int, modelContext: ModelContext) async {
        profile.age = newAge
        if let profileEntity = try? modelContext.fetch(FetchDescriptor<FitnessProfileEntity>()).first {
            profileEntity.age = newAge
            try? modelContext.save()
        }
    }
    
    func signOut() async -> Bool {
        viewState = .loading
        defer { viewState = .idle }
        do {
            try await singoutUseCase.execute()
            AppSession.shared.clearTokens()
            return true
        } catch {
            print("Error during logout: \(error.localizedDescription)")
            return false
        }
    }
}
