import SwiftUI
import Combine

class OnboardingMainViewModel: ObservableObject {
    @Published var currentStepIndex = 0
    @Published var selectedOptions: Set<String> = []
    @Published var isSelectionInProgress = false
    @Published var otherInputText: String = ""
    @Published var showOtherInput = false
    
    // Store selections for each step
    private var stepSelections: [String: Set<String>] = [:]
    
    // Height & Weight
    @Published var isMetric = false
    @Published var height: Double = 0
    @Published var weight: Double = 0
    
    // Age
    @Published var age: Int = 0
    
    // Macro breakdown
    var macroCalories: Int = 1558
    var macroProtein: Int = 118
    var macroCarbs: Int = 124
    var macroFat: Int = 64
    
    var currentStep: OnboardingStep {
        OnboardingStep.steps[currentStepIndex]
    }
    
    // Handler for single selection steps (no continue button)
    func handleSingleSelection(_ item: SelectionItem) {
        guard !isSelectionInProgress else { return }
        
        isSelectionInProgress = true
        selectedOptions = [item.id]
        stepSelections[currentStep.id] = selectedOptions
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation(.easeInOut(duration: 0.3)) {
                self.isSelectionInProgress = false
                self.moveToNextStep()
            }
        }
    }
    
    // Handler for multiple selection steps (with continue button)
    func handleMultipleSelection(_ item: SelectionItem) {
        if item.id == "other" {
            // Check for existing other input in stored selections
            let existingInput = stepSelections[currentStep.id]?.first { $0.hasPrefix("other_") }
            
            if let input = existingInput {
                // If there's existing input, restore it for editing
                otherInputText = String(input.dropFirst(6)) // Remove "other_" prefix
            } else {
                otherInputText = ""
            }
            
            showOtherInput = true
            return
        }
        
        // Remove any "other" related selections when selecting other options
        let filteredOptions = selectedOptions.filter { !$0.hasPrefix("other_") && $0 != "other" }
        selectedOptions = filteredOptions
        
        if item.id == "none" {
            selectedOptions = ["none"]
        } else {
            // Remove 'none' option if selecting something else
            if selectedOptions.contains("none") {
                selectedOptions.remove("none")
            }
            
            // Toggle the selected item
            if selectedOptions.contains(item.id) {
                selectedOptions.remove(item.id)
            } else {
                selectedOptions.insert(item.id)
            }
        }
        stepSelections[currentStep.id] = selectedOptions
    }
    
    var otherInputTitle: String {
        switch currentStep.id {
        case "health_concerns":
            return "Enter health concerns"
        case "diet":
            return "Enter specific diet"
        case "allergies":
            return "Enter food allergies"
        case "workout_duration":
            return "Enter workout duration"
        default:
            return "Enter details"
        }
    }
    
    var otherInputPlaceholder: String {
        switch currentStep.id {
        case "health_concerns":
            return "Describe your health condition"
        case "diet":
            return "Describe your diet"
        case "allergies":
            return "List your food allergies"
        case "workout_duration":
            return "Duration in minutes"
        default:
            return "Enter details"
        }
    }
    
    func submitOtherInput() {
        if !otherInputText.isEmpty {
            // Add both "other" and the input text to selections
            selectedOptions.remove("none")
            selectedOptions.insert("other")
            selectedOptions.insert("other_\(otherInputText)")
            stepSelections[currentStep.id] = selectedOptions
            showOtherInput = false
        }
    }
    
    var canProceed: Bool {
        if !currentStep.showsButton {
            return true
        }
        
        // Only check for selections if the step has options
        if !currentStep.options.isEmpty {
            return !selectedOptions.isEmpty
        }
        
        // Check specific input steps
        if currentStep.isHeightWeightStep {
            return height > 0 && weight > 0
        }
        if currentStep.isAgeStep {
            return age > 0
        }
        
        // If there's nothing to select/input, always allow proceeding
        return true
    }
    
    func moveToNextStep() {
        if currentStepIndex < OnboardingStep.steps.count - 1 {
            // Save current selections
            stepSelections[currentStep.id] = selectedOptions
            
            currentStepIndex += 1
            
            // Load selections for next step
            if !currentStep.isHeightWeightStep && !currentStep.isAgeStep && !currentStep.isMacroStep {
                selectedOptions = stepSelections[currentStep.id] ?? []
            }
        }
    }
    
    func moveToPreviousStep() {
        if currentStepIndex > 0 {
            // Save current selections
            stepSelections[currentStep.id] = selectedOptions
            
            isSelectionInProgress = false
            currentStepIndex -= 1
            
            // Load selections for previous step
            if !currentStep.isHeightWeightStep && !currentStep.isAgeStep && !currentStep.isMacroStep {
                selectedOptions = stepSelections[currentStep.id] ?? []
            }
        }
    }
}
