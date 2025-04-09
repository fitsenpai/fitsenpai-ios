import Foundation
import Combine

@MainActor
class SettingsViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var firstName: String = "Bella"
    @Published var lastName: String = "Oakley"
    @Published var age: Int = 25
    @Published var selectedGender: Gender = .female
    @Published var selectedActivityLevel: ActivityLevel = .moderate
    @Published var selectedFitnessGoal: FitnessGoals = .muscleGain
    @Published var selectedWorkoutLocation: WorkoutLocation = .home
    @Published var workoutDays: Set<Int> = [1, 3, 4, 5]  // Monday, Wednesday, Thursday, Friday
    @Published var selectedWorkoutDuration: WorkoutDuration = .thirty
    @Published var selectedDifficultyLevel: ExerciseDifficulty = .advanced
    @Published var selectedDietaryPreference: DietaryPreference = .none
    @Published var customDietaryPreference: String = ""
    @Published var selectedExerciseDifficulty: ExerciseDifficulty = .advanced
    @Published var selectedAllergies: Set<Allergy> = []
    @Published var customAllergy: String = ""
    @Published var selectedHealthConcerns: Set<HealthConcern> = []
    @Published var customHealthConcern: String = ""
    @Published var height: Double = 183.0  // Default 6ft in cm
    @Published var weight: Double = 72.0   // Default 159lb in kg
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
    init() {
        // TODO: Initialize with user data from backend
        self.firstName = "Bella"
        self.lastName = "Oakley"
        self.age = 25
        setupBindings()
    }
    
}

// MARK: Computed properties
extension SettingsViewModel {
    
    var fullname: String {
        "\(firstName) \(lastName)"
    }
    
    var displayDietaryPreference: String {
        if selectedDietaryPreference == .none {
            return "None"
        }
        if selectedDietaryPreference == .other && !customDietaryPreference.isEmpty {
            return customDietaryPreference
        }
        return selectedDietaryPreference.rawValue
    }
    
    var displayAllergies: String {
        if selectedAllergies.isEmpty || selectedAllergies == [.none] {
            return "None"
        }
        
        var display = selectedAllergies
            .filter { $0 != .other }
            .map { $0.rawValue }
        
        if selectedAllergies.contains(.other) && !customAllergy.isEmpty {
            display.append(customAllergy)
        }
        
        return display.joined(separator: ", ")
    }
    
    var displayHealthConcerns: String {
        if selectedHealthConcerns.isEmpty || selectedHealthConcerns == [.none] {
            return "None"
        }
        
        var display = selectedHealthConcerns
            .filter { $0 != .other }
            .map { $0.rawValue }
        
        if selectedHealthConcerns.contains(.other) && !customHealthConcern.isEmpty {
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
    
    func updateGender(_ gender: Gender) async {
        selectedGender = gender
        // TODO: Implement API call to update gender
    }
    
    func updateActivityLevel(_ level: ActivityLevel) async {
        selectedActivityLevel = level
        // TODO: Implement API call to update activity level
    }
    
    func updateFitnessGoal(_ goal: FitnessGoals) async {
        selectedFitnessGoal = goal
        // TODO: Implement API call to update fitness goal
    }
    
    func updateWorkoutLocation(_ location: WorkoutLocation) async {
        selectedWorkoutLocation = location
        // TODO: Implement API call
    }
    
    func updateWorkoutDays(_ days: Set<Int>) async {
        workoutDays = days
        // TODO: Implement API call
    }
    
    func updateWorkoutDuration(_ duration: WorkoutDuration) async {
        selectedWorkoutDuration = duration
        // TODO: Implement API call
    }
    
    func updateDifficultyLevel(_ level: ExerciseDifficulty) async {
        selectedDifficultyLevel = level
        // TODO: Implement API call
    }
    
    func updateDietaryPreference(_ preference: DietaryPreference, customValue: String = "") async {
        selectedDietaryPreference = preference
        if preference == .other {
            customDietaryPreference = customValue
        }
        // TODO: Implement API call
    }
    
    func updateExerciseDifficulty(_ level: ExerciseDifficulty) async {
        selectedExerciseDifficulty = level
        // TODO: Implement API call
    }
    
    func updateAllergies(_ allergies: Set<Allergy>, customValue: String = "") async {
        selectedAllergies = allergies
        if allergies.contains(.other) {
            customAllergy = customValue
        }
        // TODO: Implement API call
    }
    
    func updateHealthConcerns(_ concerns: Set<HealthConcern>, customValue: String = "") async {
        selectedHealthConcerns = concerns
        if concerns.contains(.other) {
            customHealthConcern = customValue
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

