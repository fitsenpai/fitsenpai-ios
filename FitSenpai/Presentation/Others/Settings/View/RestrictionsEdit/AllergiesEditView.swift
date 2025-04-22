import SwiftUI

struct AllergiesEditView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss

    @ObservedObject var viewModel: SettingsViewModel
    @State private var selectedAllergies: [Allergy]
    @State private var showCustomInput: Bool = false
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        _selectedAllergies = State(initialValue: viewModel.profile.allergies)
    }
    
    var body: some View {
        if showCustomInput {
            customInputView
        } else {
            mainView
        }
    }
    
    private var customInputView: some View {
        OthersInputView(
            title: "Other food allergies",
            subtitle: "Separate multiple items with a comma",
            placeholder: "Shrimp",
            initialValue: viewModel.profile.otherAllergies ?? "",
            showCustomInput: $showCustomInput,
            onSave: handleCustomInput
        )
    }
    
    private var mainView: some View {
        BaseProfileEditView(
            title: "Allergies",
            onSave: handleSave
        ) {
            restrictionsContent
        }
    }
    
    private var restrictionsContent: some View {
        RestrictionsOptionsView(
            title: "Allergies",
            options: Allergy.allCases,
            isMultiSelect: true,
            selection: .constant(Allergy.none),
            selections: $selectedAllergies,
            showCustomInput: $showCustomInput,
            isOtherOption: { $0 == .other },
            isNoneOption: { $0 == .none }
        )
    }
    
    private func handleCustomInput(_ value: String) {
        triggerHaptics()
        // When saving custom input, clear other selections and only keep "Other"
        Task { @MainActor in
            await viewModel.updateAllergies([.other], customValue: value, modelContext: modelContext)
            dismiss()
        }
    }
    
    private func handleSave() {
        triggerHaptics()
        if selectedAllergies.contains(.other) {
            showCustomInput = true
        } else {
            Task { @MainActor in
                await viewModel.updateAllergies(selectedAllergies, modelContext: modelContext)
                dismiss()
            }
        }
    }
}

#Preview {
    AllergiesEditView(viewModel: SettingsViewModel())
}
