import Foundation
import Combine

@MainActor
class SettingsViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var firstName: String = "Bella"
    @Published var lastName: String = "Oakley"
    @Published var age: Int = 25
    @Published var selectedGender: Gender?
    @Published var selectedActivityLevel: ActivityLevel?
    @Published var selectedFitnessGoal: FitnessGoals?
    @Published var selectedWorkoutLocation: WorkoutLocation?
    @Published var workoutDays: [WeekDay] = []
    @Published var selectedWorkoutDuration: WorkoutDuration?
    @Published var selectedWorkoutExperience: WorkoutExperience?
    @Published var selectedDietaryPreference: DietaryPreference?
    @Published var customDietaryPreference: String?
    @Published var selectedAllergies: [Allergy] = []
    @Published var customAllergy: String?
    @Published var selectedHealthConcerns: [HealthConcern] = []
    @Published var customHealthConcern: String?
    @Published var height: Double = 0  // Default 6ft in cm
    @Published var weight: Double = 0  // Default 159lb in kg
    @Published var isMetric: Bool = false
    @Published var viewState: ViewState = .idle
    @Published var activeSheet: FeedbackType?
    @Published var activePopup: SettingsPopup?
    @Published var isPresentedManageSubscription: Bool = false
    
    // MARK: - Private Properties
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Use Cases
    @Inject private var singoutUseCase: SignOutUseCaseProtocol
    
    // MARK: - Init
    convenience init(profile: FSProfile?) {
        
        self.init()
        guard let profile else { return }
        // Convert profile values to corresponding enums
        self.age = profile.age ?? 0
        self.height = profile.height ?? 0
        self.weight = profile.weight ?? 0
        self.selectedGender = profile.gender
        self.selectedActivityLevel = profile.activityLevel
        self.selectedFitnessGoal = profile.mainGoal
        self.selectedWorkoutLocation = profile.workoutLocation
        self.workoutDays = profile.workoutDays
        self.selectedWorkoutDuration = profile.workoutDuration
        self.selectedWorkoutExperience = profile.workoutExperience
        self.selectedDietaryPreference = profile.diet
        self.customDietaryPreference = profile.otherDiet
        self.selectedAllergies = profile.allergies
        self.customAllergy = profile.otherAllergies
        self.selectedHealthConcerns = profile.healthRestrictions
        self.customHealthConcern = profile.otherHealthRestrictions
    }
    
    init() {
        setupBindings()
    }
    
}

// MARK: Computed properties
extension SettingsViewModel {
    
    var fullname: String {
        "\(firstName) \(lastName)"
    }
    
    var displayDietaryPreference: String {
        guard let selectedDietaryPreference, selectedDietaryPreference != .none else  {
            return "None"
        }
        if selectedDietaryPreference == .other, let customDietaryPreference, !customDietaryPreference.isEmpty {
            return customDietaryPreference
        }
        return selectedDietaryPreference.title
    }
    
    var displayAllergies: String {
        if selectedAllergies.isEmpty {
            return "None"
        }
        
        var display = selectedAllergies
            .filter { $0 != .other }
            .map { $0.rawValue }
        
        if selectedAllergies.contains(.other), let customAllergy, !customAllergy.isEmpty {
            display.append(customAllergy)
        }
        
        return display.joined(separator: ", ")
    }
    
    var displayHealthConcerns: String {
        if selectedHealthConcerns.isEmpty {
            return "None"
        }
        
        var display = selectedHealthConcerns
            .filter { $0 != .other }
            .map { $0.rawValue }
        
        if selectedHealthConcerns.contains(.other), let customHealthConcern, !customHealthConcern.isEmpty {
            display.append(customHealthConcern)
        }
        
        return display.joined(separator: ", ")
    }
    
    var formattedHeightWeight: String {
        if isMetric {
            return String(format: "%.0f cm, %.0f kg", height, weight)
        } else {
            let feet = Int(floor(height / 30.48))
            let inches = Int((height.truncatingRemainder(dividingBy: 30.48) / 2.54).rounded())
            let pounds = Int(weight * 2.20462)
            return String(format: "%d'%d\", %d lb", feet, inches, pounds)
        }
    }
}

// MARK: Private functions
private extension SettingsViewModel {
    func setupBindings() {
        $selectedGender
            .dropFirst()
            .sink { [weak self] gender in
                Task {
                    await self?.updateGender(gender)
                }
            }
            .store(in: &cancellables)
        
        $selectedActivityLevel
            .dropFirst()
            .sink { [weak self] level in
                Task {
                    await self?.updateActivityLevel(level)
                }
            }
            .store(in: &cancellables)
        
        $selectedFitnessGoal
            .dropFirst()
            .sink { [weak self] goal in
                Task {
                    await self?.updateFitnessGoal(goal)
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: API UseCase functions
extension SettingsViewModel {
    func updateName(firstName: String, lastName: String) async {
        self.firstName = firstName
        self.lastName = lastName
        // TODO: Implement API call to update name
    }
    
    func updateAge(_ newAge: Int) async {
        age = newAge
        // TODO: Implement API call to update age
    }
    
    func updateGender(_ gender: Gender?) async {
        selectedGender = gender
        // TODO: Implement API call to update gender
    }
    
    func updateActivityLevel(_ level: ActivityLevel?) async {
        selectedActivityLevel = level
        // TODO: Implement API call to update activity level
    }
    
    func updateFitnessGoal(_ goal: FitnessGoals?) async {
        selectedFitnessGoal = goal
        // TODO: Implement API call to update fitness goal
    }
    
    func updateWorkoutLocation(_ location: WorkoutLocation?) async {
        selectedWorkoutLocation = location
        // TODO: Implement API call
    }
    
    func updateWorkoutDays(_ days: [WeekDay]) async {
        workoutDays = days
        // TODO: Implement API call
    }
    
    func updateWorkoutDuration(_ duration: WorkoutDuration?) async {
        selectedWorkoutDuration = duration
        // TODO: Implement API call
    }
    
    func updateDietaryPreference(_ preference: DietaryPreference?, customValue: String = "") async {
        selectedDietaryPreference = preference
        if preference == .other {
            customDietaryPreference = customValue
        } else {
            customDietaryPreference = nil
        }
        // TODO: Implement API call
    }
    
    func updateExerciseDifficulty(_ level: WorkoutExperience?) async {
        selectedWorkoutExperience = level
        // TODO: Implement API call
    }
    
    func updateAllergies(_ allergies: [Allergy], customValue: String = "") async {
        selectedAllergies = allergies
        if allergies.contains(.other) {
            customAllergy = customValue
        } else {
            customAllergy = nil
        }
        // TODO: Implement API call
    }
    
    func updateHealthConcerns(_ concerns: [HealthConcern], customValue: String = "") async {
        selectedHealthConcerns = concerns
        if concerns.contains(.other) {
            customHealthConcern = customValue
        } else {
            customAllergy = nil
        }
        // TODO: Implement API call
    }
    
    func updateHeightWeight(height: Double, weight: Double, isMetric: Bool) async {
        self.height = height
        self.weight = weight
        self.isMetric = isMetric
        // Add any API calls or data persistence here
    }
    
    func signOut() async -> Bool {
        viewState = .loading
        defer { viewState = .idle }
        do {
            try await singoutUseCase.execute()
            
            // Clear session in AuthUseCase as part of logout
            AppSession.shared.clearTokens()
            
            return true
        } catch {
            print("Error during logout: \(error.localizedDescription)")
            return false
        }
    }
}
