//
//  OnboardingMainViewModel.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/1/25.
//

import SwiftUI
import Combine
import UserNotifications

class OnboardingMainViewModel: ObservableObject {
    @Published var currentStepIndex = 0
    @Published var selectedOptions: Set<String> = []
    @Published var isSelectionInProgress = false
    @Published var otherInputText: String = ""
    @Published var showOtherInput = false
    @Published var onboardingSheet: OnboardingSheets? = nil
    
    // Store selections for each step
    private var stepSelections: [String: Set<String>] = [:]
    private var stepInputs: [String: String] = [:]
    
    // Input text for other inputs
    @Published var inputText: String = ""
    
    var inputTextPlaceHolder: String {
        if case .input(_, let placeholder) = currentStep.type {
            return placeholder
        }
        return ""
    }
    
    
    
    // Height & Weight
    @Published var isMetric = false {
        didSet {
            // Convert values when measurement system changes
            if isMetric {
                // Convert from imperial to metric
                height = height * 2.54 // inches to cm
                weight = weight * 0.453592 // lbs to kg
            } else {
                // Convert from metric to imperial
                height = height / 2.54 // cm to inches
                weight = weight / 0.453592 // kg to lbs
            }
        }
    }
    @Published var height: Double = 70 // Default: 5'10" (70 inches) / 177.8cm
    @Published var weight: Double = 150 // Default: 150lbs / 68kg
    
    // Age
    @Published var age: Int = 18
    
    // Macro breakdown
    var macroCalories: Int = 1558
    var macroProtein: Int = 118
    var macroCarbs: Int = 124
    var macroFat: Int = 64
    
    // ADD: Track navigation direction
    @Published var isMovingForward: Bool = true

    var currentStep: OnboardingStep {
        OnboardingStep.steps[currentStepIndex]
    }
    
    var progress: Double {
        let totalSteps = Double(OnboardingStep.steps.count)
        let currentStep = Double(currentStepIndex + 1)
        return currentStep / totalSteps
    }
    
    // Handler for single selection steps (no continue button)
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
    
    // Handler for multiple selection steps (with continue button)
    func handleMultipleSelection(_ item: SelectionItem) {
        triggerHaptics()
        if item.id == "other" {
            selectedOptions = ["other"]
            // Restore previous input if it exists
            inputText = stepInputs[currentStep.id] ?? ""
        } else if item.id == "none" {
            selectedOptions = ["none"]
            inputText = ""
            stepInputs.removeValue(forKey: currentStep.id)
        } else {
            if selectedOptions.contains("none") {
                selectedOptions.remove("none")
            }
            if selectedOptions.contains("other") {
                selectedOptions.remove("other")
                inputText = ""
                stepInputs.removeValue(forKey: currentStep.id)
            }
            
            if selectedOptions.contains(item.id) {
                selectedOptions.remove(item.id)
            } else {
                selectedOptions.insert(item.id)
            }
        }
        stepSelections[currentStep.id] = selectedOptions
    }
    
    func getInputStepId(for stepId: String) -> String {
        switch stepId {
        case "health_restrictions":
            return "health_restrictions_input"
        case "diet":
            return "diet_input"
        case "allergies":
            return "allergies_input"
        default:
            return stepId
        }
    }
    
    var canProceed: Bool {
        if !currentStep.showsButton {
            return true
        }
        
        if currentStep.isInputStep {
            return !inputText.isEmpty
        }
        
        // Only check for selections if the step has options
        if !currentStep.options.isEmpty {
            return !selectedOptions.isEmpty
        }
        
        if currentStep.isHeightWeightStep {
            return height > 0 && weight > 0
        }
        if currentStep.isAgeStep {
            return age > 0
        }
        
        return true
    }
    
    private func wasFromInputStep(_ currentIndex: Int) -> Bool {
        // Check if the previous step in our navigation was an input step
        if currentIndex - 2 >= 0 {
            let previousStep = OnboardingStep.steps[currentIndex - 2]
            return previousStep.isInputStep
        }
        return false
    }

    func moveToNextStep() {
        isMovingForward = true

        // Save current state
        if currentStep.isInputStep {
            if case .input(let previousStep, _) = currentStep.type {
                stepInputs[previousStep] = inputText
                currentStepIndex += 1
                selectedOptions = stepSelections[currentStep.id] ?? []
                inputText = ""
            }
            return
        }
        
        // Save current selections
        stepSelections[currentStep.id] = selectedOptions
        if selectedOptions.contains("other") {
            stepInputs[currentStep.id] = inputText
        }
        
        // Check if next step is input step
        let nextIndex = currentStepIndex + 1
        if nextIndex < OnboardingStep.steps.count {
            let nextStep = OnboardingStep.steps[nextIndex]
            
            if nextStep.isInputStep {
                // Only go to input step if current step has "other" selected
                if selectedOptions.contains("other") {
                    currentStepIndex = nextIndex
                    inputText = stepInputs[currentStep.id] ?? ""
                } else {
                    // Skip input step
                    currentStepIndex = nextIndex + 1
                    selectedOptions = stepSelections[OnboardingStep.steps[nextIndex + 1].id] ?? []
                    inputText = ""
                }
            } else {
                // Normal next step
                currentStepIndex = nextIndex
                selectedOptions = stepSelections[nextStep.id] ?? []
                inputText = ""
            }
        }
    }
    
    func moveToPreviousStep() {
        // ADD: Set direction to backward
        isMovingForward = false
        
        if currentStepIndex > 0 {
            // If in input step, go back to selection step
            if currentStep.isInputStep {
                currentStepIndex -= 1
                selectedOptions = stepSelections[currentStep.id] ?? []
                inputText = stepInputs[currentStep.id] ?? ""
                return
            }
            
            // Save current state
            stepSelections[currentStep.id] = selectedOptions
            if selectedOptions.contains("other") {
                stepInputs[currentStep.id] = inputText
            }
            
            // Check if previous step was input
            let previousStep = OnboardingStep.steps[currentStepIndex - 1]
            if previousStep.isInputStep {
               
                // Check if we should show input step
                if case .input(let originalStepId, _) = previousStep.type {

                    if let originalSelections = stepSelections[originalStepId],
                       originalSelections.contains("other") {
                        currentStepIndex -= 1
                        inputText = stepInputs[originalStepId] ?? ""
                        return
                    }
                }
                // Skip input step if "other" not selected
                currentStepIndex -= 2
            } else {
                currentStepIndex -= 1
            }
            
            selectedOptions = stepSelections[currentStep.id] ?? []
            inputText = stepInputs[currentStep.id] ?? ""
        }
    }
    
    // ADD: Function to request notification permissions
    func requestNotificationPermission() {
        self.triggerHaptics()
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            DispatchQueue.main.async {
                if granted {
                    self.onboardingSheet = .success
                } else {
                    self.moveToNextStep()
                }
            }
        }
    }
    
    // Modify showOnboardingSheet function
    func showOnboardingSheet(_ sheet: OnboardingSheets) {
        triggerHaptics()
        self.onboardingSheet = sheet
    }
    
    func logSelections() {
        print("=== Onboarding Selections ===")
        
        // Log all step selections
        for step in OnboardingStep.steps {
            if let selections = stepSelections[step.id] {
                print("\(step.title):")
                if selections.contains("other") {
                    print("- Other: \(stepInputs[step.id] ?? "")")
                } else {
                    selections.forEach { selection in
                        print("- \(selection)")
                    }
                }
            }
        }
        
        // Log measurements
        print("\nMeasurements:")
        print("Height: \(height) \(isMetric ? "cm" : "inches")")
        print("Weight: \(weight) \(isMetric ? "kg" : "lbs")")
        
        // Log age
        print("\nAge: \(age)")
        
        print("=== End of Selections ===")
    }
    
    func triggerHaptics() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
}
