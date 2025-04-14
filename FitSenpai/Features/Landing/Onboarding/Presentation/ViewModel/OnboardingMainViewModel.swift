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
    @Published var selectedOptions: Set<String> = []
    @Published var isSelectionInProgress = false
    @Published var otherInputText: String = ""
    @Published var showOtherInput = false
    @Published var onboardingSheet: OnboardingSheets? = nil
    @Published private(set) var navigationDirection: NavigationDirection = .forward
    
    @Published var height: Double = 70
    @Published var weight: Double = 150
    @Published var age: Int = 18
    
    // Macro breakdown
    @Published var macroCalories: Int = 1558
    @Published var macroProtein: Int = 118
    @Published var macroCarbs: Int = 124
    @Published var macroFat: Int = 64
    
    // Store selections for each step
    private var stepSelections: [StepID: Set<String>] = [:]
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
        if item.id == "other" {
            selectedOptions = ["other"]
            inputText = stepInputs[currentStep.id] ?? ""
        } else if item.id == "none" {
            selectedOptions = ["none"]
            clearInput()
        } else {
            selectedOptions.remove("none")
            selectedOptions.remove("other")
            clearInput()
            
            if selectedOptions.contains(item.id) {
                selectedOptions.remove(item.id)
            } else {
                selectedOptions.insert(item.id)
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
        selectedOptions = [item.id]
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
        if selectedOptions.contains("other") {
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
            if selectedOptions.contains("other") {
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
               originalSelections.contains("other") {
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
    
    // IMPROVE: Structured logging
    func logSelections() {
        var log = ["=== Onboarding Selections ===\n"]
        
        // Step selections
        OnboardingStep.steps.forEach { step in
            if let selections = stepSelections[step.id] {
                log.append("\(step.title):")
                if selections.contains("other") {
                    log.append("- Other: \(stepInputs[step.id] ?? "")")
                } else {
                    selections.forEach { log.append("- \($0)") }
                }
            }
        }
        
        // Measurements
        log.append("\nMeasurements:")
        log.append("Height: \(height) \(isMetric ? "cm" : "inches")")
        log.append("Weight: \(weight) \(isMetric ? "kg" : "lbs")")
        log.append("\nAge: \(age)")
        log.append("=== End of Selections ===")
        
        print(log.joined(separator: "\n"))
    }
}
