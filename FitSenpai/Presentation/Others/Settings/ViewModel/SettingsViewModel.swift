import Foundation
import Combine
import SwiftData
import CoreKit

@MainActor
class SettingsViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var firstName: String = "Bella"
    @Published var lastName: String = "Oakley"
    @Published var user: FSUser?
    @Published var profile = UserProfile()
    @Published var viewState: ViewState = .idle
    @Published var activeSheet: FeedbackType?
    @Published var activePopup: SettingsPopup?
    @Published var isPresentedManageSubscription: Bool = false
    
    // MARK: - Private Properties
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Use Cases
    @Inject private var singoutUseCase: SignOutUseCaseProtocol
    @Inject private var getUserProfileUseCase: GetUserProfileUseCaseProtocol
    @Inject private var getUserUseCase: GetUserAuthUseCaseProtocol
    @Inject private var saveUserProfileUseCase: SaveUserProfileUseCaseProtocol

    // MARK: - Init
    init() {
        self.initializeData()
    }
}

// MARK: Computed properties
extension SettingsViewModel {
    
    var fullname: String {
        "\(firstName) \(lastName)"
    }
    
    var displayDietaryPreference: String {
        guard let item = profile.dietPreference, let value = DietPreferenceType(rawValue: item.id), value != .none else {
            return "None"
        }
        
        if value == .other, let customDiet = profile.otherDietPreference, !customDiet.isEmpty {
            return customDiet
        }
        
        return value.title
    }
    
    var displayAllergies: String {
        let allergies = profile.allergies.compactMap({ AllergyType(rawValue: $0.id) })
        let customAllergy = profile.otherAllergies
        
        guard !allergies.isEmpty else {
            return "None"
        }
        
        var display = allergies
            .filter { $0 != .other }
            .map { $0.title }
        
        if allergies.contains(.other), !customAllergy.isEmpty {
            display.append(contentsOf: customAllergy)
        }
        
        return display.joined(separator: ", ")
    }
    
    var displayHealthConcerns: String {
        let healthRestrictions = profile.healthConcerns.compactMap({ HealthConcernType(rawValue: $0.id) })
        guard !healthRestrictions.isEmpty else {
            return "None"
        }
        
        var display = healthRestrictions
            .filter { $0 != .other }
            .map { $0.title }
        
        if healthRestrictions.contains(.other), let customHealth = profile.otherHealthConcern, !customHealth.isEmpty {
            display.append(customHealth)
        }
        
        return display.joined(separator: ", ")
    }
    
    var formattedHeightWeight: String {
        guard let value = profile.systemOfMeasurement, let measurement = MeasurementType(rawValue: value.id) else { return "" }
        
        if measurement == .metric {
            return String(format: "%.0f cm, %.0f kg", Double(profile.height ?? 0), Double(profile.weight ?? 0))
        } else {
            let heightInCm = Double(profile.height ?? 0)
            let weightInCm = Double(profile.weight ?? 0)
            let feet = Int(floor(heightInCm / 30.48))
            let inches = Int((heightInCm.truncatingRemainder(dividingBy: 30.48) / 2.54).rounded())
            let pounds = Int(weightInCm * 2.20462)
            return String(format: "%d'%d\", %d lb", feet, inches, pounds)
        }
    }
}

// MARK: Update functions
extension SettingsViewModel {
    
    func initializeData() {
        Task { @MainActor in
            viewState = .loading
            defer { viewState = .idle }
            async let user = self.getUserUseCase.execute()
            async let profile = self.getUserProfileUseCase.execute()
            self.user = try await user
            self.profile = try await profile
        }
    }
    
    private func saveProfile() async throws {
        self.viewState = .loading
        defer { self.viewState = .idle }
        let profilreResponse = try await saveUserProfileUseCase.execute(self.profile)
        if let profilreResponse {
            self.profile = profilreResponse
        }
    }
    
    func getTitle<T: SelectableItemProtocol>(
        for keyPath: WritableKeyPath<UserProfile, OptionItem?>,
        as type: T.Type
    ) -> String where T.RawValue == String {
        let id = profile[keyPath: keyPath]?.id ?? ""
        return type.from(rawValue: id)?.title ?? ""
    }
    
    func updateProfileOption<T: SelectableItemProtocol>(
        _ selection: T?,
        for keyPath: WritableKeyPath<UserProfile, OptionItem?>
    ) async {
        profile[keyPath: keyPath] = selection?.toOption()
        try? await saveProfile()
    }
    
    func updateProfileOption<T: SelectableItemProtocol>(
        _ selections: [T],
        for keyPath: WritableKeyPath<UserProfile, [OptionItem]>
    ) async {
        profile[keyPath: keyPath] = selections.map({ $0.toOption() })
        try? await saveProfile()
    }
    
    func updateDietaryPreference(_ preference: DietPreferenceType?, customValue: String = "") async {
        profile.dietPreference = preference?.toOption()
        profile.otherDietPreference = preference == .other ? customValue : nil
        try? await saveProfile()
    }
    
    func updateAllergies(_ allergies: [AllergyType], customValue: String = "") async {
        profile.allergies = allergies.map({ $0.toOption() })
        let customValues = customValue.split(separator: ",").map({ String($0) })
        profile.otherAllergies = allergies.contains(.other) ? customValues : []
        try? await saveProfile()
    }
    
    func updateHealthConcerns(_ concerns: [HealthConcernType], customValue: String = "") async {
        profile.healthConcerns = concerns.map({ $0.toOption() })
        profile.otherHealthConcern = concerns.contains(.other) ? customValue : nil
        try? await saveProfile()
    }
    
    func updateHeightWeight(height: Double, weight: Double, measurement: MeasurementType) async {
        profile.height = Int(height)
        profile.weight = Int(weight)
        profile.systemOfMeasurement = measurement.toOption()
        try? await saveProfile()
    }
    
    func updateName(firstName: String, lastName: String) async {
        self.firstName = firstName
        self.lastName = lastName
        // TODO: Implement API call to update name
    }
    
    func updateAge(_ newAge: Int) async {
        profile.birthYear = "\(newAge)"
        try? await saveProfile()
    }
    
    func signOut() async -> Bool {
        viewState = .loading
        defer { viewState = .idle }
        do {
            try await singoutUseCase.execute()
            NetworkSession.shared.clearTokens()
            return true
        } catch {
            print("Error during logout: \(error.localizedDescription)")
            return false
        }
    }
}
