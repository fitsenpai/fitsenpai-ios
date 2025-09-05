//
//  CreateProfileViewModel.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/1/25.
//

import SwiftUI
import Combine
import UserNotifications
import CoreKit

enum NavigationDirection {
    case forward
    case backward
}

class CreateProfileViewModel: ObservableObject {
    @Published var currentStepIndex = 0
    @Published var selectedOptions: [SelectionItem] = []
    @Published var isSelectionInProgress = false
    @Published var otherInputText: String = ""
    @Published var showOtherInput = false
    @Published var navSheets: CreateProfileSheets? = nil
    @Published private(set) var navigationDirection: NavigationDirection = .forward
    
    // Always store in metric (cm and kg)
    @Published var height: Double = 170 // Default to 170 cm
    @Published var weight: Double = 70  // Default to 70 kg
    @Published var age: Int = 18
    
    // Macro breakdown
    @Published var macroCalories: Int = 0
    @Published var macroProtein: Int = 0
    @Published var macroCarbs: Int = 0
    @Published var macroFat: Int = 0
    
    // Input text for other inputs
    @Published var inputText: String = ""
    
    // Store selections for each step
    private var stepSelections: [StepID: [SelectionItem]] = [:]
    private var stepInputs: [StepID: String] = [:]
    
    // IMPROVE: Input text placeholder computed property
    var inputTextPlaceHolder: String {
        guard case .input(_, let placeholder) = currentStep.type else { return "" }
        return placeholder
    }
    
    // Height & Weight - display preference only, doesn't affect stored values
    @Published var isMetric = false
    
    var currentStep: OnboardingStep {
        OnboardingStep.steps[currentStepIndex]
    }
    
    var progress: Double {
        Double(currentStepIndex + 1) / Double(OnboardingStep.steps.count)
    }
    
    // IMPROVE: Selection handling
    private func updateSelections(with item: SelectionItem) {
        if item.isOthers {
            selectedOptions = [item]
            inputText = stepInputs[currentStep.id] ?? ""
        } else if item.isNone {
            selectedOptions = [item]
            clearInput()
        } else {
            selectedOptions.removeAll { $0.isOthers || $0.isNone }
            clearInput()
            
            if let index = selectedOptions.firstIndex(where: { $0.id == item.id }) {
                selectedOptions.remove(at: index)
            } else {
                selectedOptions.append(item)
            }
        }
        stepSelections[currentStep.id] = selectedOptions
    }
    
    private func clearInput() {
        inputText = ""
        stepInputs.removeValue(forKey: currentStep.id)
    }
    
    // Handler for single selection steps
    func handleSingleSelection(_ item: SelectionItem) {
        guard !isSelectionInProgress else { return }
        
        isSelectionInProgress = true
        selectedOptions = [item]
        stepSelections[currentStep.id] = selectedOptions
        triggerHaptics()
        
        // adds animation after selection before going to next step
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.easeInOut(duration: 0.2)) {
                self.moveToNextStep()
            }
        }
        
        // adds delay to prevent multiple clicks
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
               self.isSelectionInProgress = false
        }
    }
    
    // Handler for multiple selection steps
    func handleMultipleSelection(_ item: SelectionItem) {
        triggerHaptics()
        updateSelections(with: item)
    }
    
    func getInputStepId(for stepId: String) -> String {
        switch stepId {
        case "health_restrictions": return "health_restrictions_input"
        case "diet": return "diet_input"
        case "allergies": return "allergies_input"
        default: return stepId
        }
    }
    
    var canProceed: Bool {
        if !currentStep.showsButton { return true }
        if currentStep.isInputStep { return !inputText.isEmpty }
        if !currentStep.options.isEmpty { return !selectedOptions.isEmpty }
        if currentStep.isHeightWeightStep { return height > 0 && weight > 0 }
        if currentStep.isAgeStep { return age > 0 }
        return true
    }
    
    func moveToNextStep() {
        navigationDirection = .forward
        handleStepNavigation()
    }
    
    func moveToPreviousStep() {
        navigationDirection = .backward
        handleStepNavigation()
    }
    
    func showOnboardingSheet(_ sheet: CreateProfileSheets) {
        triggerHaptics()
        navSheets = sheet
    }
    
    func getValue(for id: StepID) -> OptionItem {
        return .init(id: stepSelections[id]?.first?.stringId)
    }
    
    func getValues(for id: StepID) -> [OptionItem] {
        let values = stepSelections[id]?
            .compactMap({ $0.stringId })
            .compactMap({ OptionItem(id: $0) })
        return values ?? []
    }

    func createProfile() -> UserProfile {
        // No conversion needed here since we always store in metric
        return UserProfile(
            createdAt: Date().formatted(date: .complete, time: .complete),
            gender: getValue(for: .gender),
            activityLevel: getValue(for: .activityLevel),
            previousExperience: getValues(for: .pastTraining),
            height: Int(height),      // Already in cm
            weight: Int(weight),      // Already in kg
            isMetric: isMetric,
            age: age,
            mainGoal: getValue(for: .mainGoal),
            fitnessBarrier: getValue(for: .barriers),
            fitnessGoal: getValue(for: .goals),
            workoutExperience: getValue(for: .workoutExperience),
            workoutLocation: getValue(for: .workoutLocation),
            workoutDays: getValues(for: .workoutDays),
            workoutDuration: getValue(for: .workoutDuration),
            healthConcerns: getValues(for: .healthRestrictions),
            otherHealthConcern: stepInputs[.healthRestrictions],
            dietPreference: getValue(for: .diet),
            otherDietPreference: stepInputs[.diet],
            allergies: getValues(for: .allergies),
            otherAllergies: stepInputs[.allergies].map { [$0] } ?? [],
            cookingStyle: getValue(for: .cookingStyle)
        )
    }
    private func handleStepNavigation() {
        saveCurrentState()
        
        switch navigationDirection {
        case .forward:
            handleForwardNavigation()
        case .backward:
            handleBackwardNavigation()
        }
    }
    
    private func saveCurrentState() {
        if currentStep.isInputStep {
            if case .input(let previousStep, _) = currentStep.type {
                stepInputs[previousStep] = inputText
            }
        }
        
        stepSelections[currentStep.id] = selectedOptions
        if selectedOptions.contains(where: { $0.isOthers }) {
            stepInputs[currentStep.id] = inputText
        }
    }
    
    private func handleForwardNavigation() {
        let nextIndex = currentStepIndex + 1
        guard nextIndex < OnboardingStep.steps.count else { return }
        
        if currentStep.isInputStep {
            currentStepIndex += 1
            selectedOptions = stepSelections[currentStep.id] ?? []
            inputText = ""
            return
        }
        
        let nextStep = OnboardingStep.steps[nextIndex]
        if nextStep.isInputStep {
            if selectedOptions.contains(where: { $0.isOthers }) {
                currentStepIndex = nextIndex
                inputText = stepInputs[currentStep.id] ?? ""
            } else {
                currentStepIndex = nextIndex + 1
                selectedOptions = stepSelections[OnboardingStep.steps[nextIndex + 1].id] ?? []
                inputText = ""
            }
        } else {
            currentStepIndex = nextIndex
            selectedOptions = stepSelections[nextStep.id] ?? []
            inputText = ""
        }
    }
    
    private func handleBackwardNavigation() {
        guard currentStepIndex > 0 else { return }
        
        if currentStep.isInputStep {
            currentStepIndex -= 1
            selectedOptions = stepSelections[currentStep.id] ?? []
            inputText = stepInputs[currentStep.id] ?? ""
            return
        }
        
        let previousStep = OnboardingStep.steps[currentStepIndex - 1]
        if previousStep.isInputStep {
            if case .input(let originalStepId, _) = previousStep.type,
               let originalSelections = stepSelections[originalStepId],
               originalSelections.contains(where: { $0.isOthers }) {
                currentStepIndex -= 1
                inputText = stepInputs[originalStepId] ?? ""
            } else {
                currentStepIndex -= 2
            }
        } else {
            currentStepIndex -= 1
        }
        
        selectedOptions = stepSelections[currentStep.id] ?? []
        inputText = stepInputs[currentStep.id] ?? ""
    }
    
    // IMPROVE: Notification handling with completion
    func requestNotificationPermission() {
        triggerHaptics()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Notification permission error: \(error.localizedDescription)")
                }
                self?.handleNotificationPermissionResponse(granted: granted)
            }
        }
    }
    
    private func handleNotificationPermissionResponse(granted: Bool) {
        if granted {
            navSheets = .success
        } else {
            moveToNextStep()
        }
    }

    private func getSelectedTitle(for stepID: StepID) -> String {
        guard let selections = stepSelections[stepID],
              let firstSelection = selections.first,
              let step = OnboardingStep.steps.first(where: { $0.id == stepID }),
              let option = step.options.first(where: { $0.id == firstSelection.id }) else {
            return ""
        }
        return option.title
    }

    private func getSelectedTitles(for stepID: StepID) -> [String] {
        guard let selections = stepSelections[stepID],
              let step = OnboardingStep.steps.first(where: { $0.id == stepID }) else {
            return []
        }
        return selections.compactMap { selection in
            step.options.first { $0.id == selection.id }?.title
        }
    }

    private func getCombinedTitles(for stepID: StepID, inputStep: StepID) -> [String] {
        var titles = getSelectedTitles(for: stepID)
        if let selections = stepSelections[stepID],
           selections.contains(where: { $0.isOthers }),
           let input = stepInputs[stepID] {
            let additionalValues = input.split(separator: ",").map { String($0.trimmingCharacters(in: .whitespaces)) }
            titles.removeAll { $0.lowercased() == "other" }
            titles.append(contentsOf: additionalValues)
        }
        return titles.filter { !$0.isEmpty && $0.lowercased() != "none" }
    }

    private func getCombinedTitle(for stepID: StepID, inputStep: StepID) -> String {
        if let selections = stepSelections[stepID],
           selections.contains(where: { $0.isOthers }),
           let input = stepInputs[stepID] {
            return input.trimmingCharacters(in: .whitespaces)
        }
        return getSelectedTitle(for: stepID)
    }
}

// MARK: - Macro Calculation
extension CreateProfileViewModel {
    func calculateMacros() {
        let gender: MacroCalculator.Gender
        if stepSelections[.gender]?.contains(where: { $0.id == 1 }) ?? false {
            gender = .male
        } else if stepSelections[.gender]?.contains(where: { $0.id == 2 }) ?? false {
            gender = .female
        } else {
            gender = .other
        }
        
        let activityLevel: MacroCalculator.ActivityLevel
        if stepSelections[.activityLevel]?.contains(where: { $0.id == 1 }) ?? false {
            activityLevel = .sedentary
        } else if stepSelections[.activityLevel]?.contains(where: { $0.id == 2 }) ?? false {
            activityLevel = .light
        } else if stepSelections[.activityLevel]?.contains(where: { $0.id == 3 }) ?? false {
            activityLevel = .moderate
        } else if stepSelections[.activityLevel]?.contains(where: { $0.id == 4 }) ?? false {
            activityLevel = .heavy
        } else if stepSelections[.activityLevel]?.contains(where: { $0.id == 5 }) ?? false {
            activityLevel = .athlete
        } else {
            activityLevel = .sedentary
        }
        
        let goal: MacroCalculator.FitnessGoal
        if stepSelections[.mainGoal]?.contains(where: { $0.id == 1 }) ?? false {
            goal = .fatLoss
        } else if stepSelections[.mainGoal]?.contains(where: { $0.id == 2 }) ?? false {
            goal = .muscleGain
        } else if stepSelections[.mainGoal]?.contains(where: { $0.id == 3 }) ?? false {
            goal = .generalFitness
        } else if stepSelections[.mainGoal]?.contains(where: { $0.id == 4 }) ?? false {
            goal = .endurance
        } else if stepSelections[.mainGoal]?.contains(where: { $0.id == 5 }) ?? false {
            goal = .aesthetic
        } else {
            goal = .fatLoss
        }
        
        let calculator = MacroCalculator(
            height: height,
            weight: weight,
            age: age,
            gender: gender,
            activityLevel: activityLevel,
            goal: goal,
            isMetric: isMetric
        )
        
        let macros = calculator.calculateMacros()
        
        macroCalories = macros.calories
        macroProtein = macros.protein
        macroFat = macros.fat
        macroCarbs = macros.carbs
    }
}
