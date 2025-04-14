//
//  OnboardingMainViewModel.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/1/25.
//

import SwiftUI
import Combine
import UserNotifications

// ADD: Navigation direction enum
enum NavigationDirection {
    case forward
    case backward
}

class OnboardingMainViewModel: ObservableObject {
    @Published var currentStepIndex = 0
    @Published var selectedOptions: [SelectionItem] = []
    @Published var isSelectionInProgress = false
    @Published var otherInputText: String = ""
    @Published var showOtherInput = false
    @Published var onboardingSheet: OnboardingSheets? = nil
    @Published private(set) var navigationDirection: NavigationDirection = .forward
    
    @Published var height: Double = 70
    @Published var weight: Double = 150
    @Published var age: Int = 18
    
    // Macro breakdown
    @Published var macroCalories: Int = 0
    @Published var macroProtein: Int = 0
    @Published var macroCarbs: Int = 0
    @Published var macroFat: Int = 0
    
    // Store selections for each step
    private var stepSelections: [StepID: [SelectionItem]] = [:]
    private var stepInputs: [StepID: String] = [:]
    
    // Input text for other inputs
    @Published var inputText: String = ""
    
    // IMPROVE: Input text placeholder computed property
    var inputTextPlaceHolder: String {
        guard case .input(_, let placeholder) = currentStep.type else { return "" }
        return placeholder
    }
    
    // Height & Weight
    @Published var isMetric = false {
        didSet { convertMeasurements(toMetric: isMetric) }
    }
    
    var currentStep: OnboardingStep {
        OnboardingStep.steps[currentStepIndex]
    }
    
    var progress: Double {
        Double(currentStepIndex + 1) / Double(OnboardingStep.steps.count)
    }
    
    // IMPROVE: Separate measurement conversion logic
    private func convertMeasurements(toMetric: Bool) {
        if toMetric {
            height *= 2.54 // inches to cm
            weight *= 0.453592 // lbs to kg
        } else {
            height /= 2.54 // cm to inches
            weight /= 0.453592 // kg to lbs
        }
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.easeInOut(duration: 0.3)) {
                self.isSelectionInProgress = false
                self.moveToNextStep()
            }
        }
    }
    
    // Handler for multiple selection steps
    func handleMultipleSelection(_ item: SelectionItem) {
        triggerHaptics()
        updateSelections(with: item)
    }
    
    // IMPROVE: Input step ID handling
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
    
    // IMPROVE: Navigation state management
    func moveToNextStep() {
        navigationDirection = .forward
        handleStepNavigation()
    }
    
    func moveToPreviousStep() {
        navigationDirection = .backward
        handleStepNavigation()
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
            onboardingSheet = .success
        } else {
            moveToNextStep()
        }
    }
    
    func showOnboardingSheet(_ sheet: OnboardingSheets) {
        triggerHaptics()
        onboardingSheet = sheet
    }
    
    func getValue<T: SelectableItemProtocol>(for id: StepID) -> T? {
        let value = stepSelections[id]?.first?.id
        return T(rawValue: value)
    }
    
    func getValues<T: SelectableItemProtocol>(for id: StepID) -> [T]? {
        let value = stepSelections[id]?
            .compactMap({ $0.id }).compactMap({ T(rawValue: $0) })
        return value
    }

    // CHANGE: createProfile() method implementation
    func createProfile() -> FSProfile {
        return FSProfile(
            gender: getValue(for: .gender),
            activityLevel: getValue(for: .activityLevel),
            mainGoal: getValue(for: .mainGoal),
            height: height > 0 ? height : nil,
            weight: weight > 0 ? weight : nil,
            age: age > 0 ? age : nil,
            workoutExperience: getValue(for: .workoutExperience),
            workoutLocation: getValue(for: .workoutLocation),
            workoutDays: getValues(for: .workoutDays) ?? [],
            workoutDuration: getValue(for: .workoutDuration),
            healthRestrictions: getValues(for: .healthRestrictions) ?? [],
            otherHealthRestrictions: stepInputs[.healthRestrictions],
            diet: getValue(for: .diet),
            otherDiet: stepInputs[.diet],
            allergies: getValues(for: .allergies) ?? [],
            otherAllergies: stepInputs[.allergies],
            cookingStyle: getValue(for: .cookingStyle),
            pastTrainings: getValues(for: .pastTraining) ?? [],
            barriers: getValue(for: .barriers),
            goals: getValue(for: .goals),
            isMetric: isMetric
        )
    }

    // ADD: Helper methods for getting stored selections
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

    // IMPROVE: Notification handling with completion
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

extension OnboardingMainViewModel {
    
}
