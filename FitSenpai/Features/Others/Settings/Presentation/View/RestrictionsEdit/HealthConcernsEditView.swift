import SwiftUI

struct HealthConcernsEditView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss

    @ObservedObject var viewModel: SettingsViewModel
    @State private var selectedConcerns: [HealthConcern]
    @State private var showCustomInput: Bool = false
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        _selectedConcerns = State(initialValue: viewModel.profile.healthRestrictions)
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
            title: "Other health concerns",
            subtitle: "Separate multiple items with a comma",
            placeholder: "Shoulder injury",
            initialValue: viewModel.profile.otherHealthRestrictions ?? "",
            showCustomInput: $showCustomInput,
            onSave: handleCustomInput
        )
    }
    
    private var mainView: some View {
        BaseProfileEditView(
            title: "Health Concerns",
            onSave: handleSave
        ) {
            restrictionsContent
        }
    }
    
    private var restrictionsContent: some View {
        RestrictionsOptionsView(
            title: "Health Concerns",
            options: HealthConcern.allCases,
            isMultiSelect: true,
            selection: .constant(HealthConcern.none),
            selections: $selectedConcerns,
            showCustomInput: $showCustomInput,
            isOtherOption: { $0 == .other },
            isNoneOption: { $0 == .none }
        )
    }
    
    private func handleCustomInput(_ value: String) {
        triggerHaptics()
        // When saving custom input, clear other selections and only keep "Other"
        Task { @MainActor in
            await viewModel.updateHealthConcerns([.other], customValue: value, modelContext: modelContext)
            dismiss()
        }
    }
    
    private func handleSave() {
        triggerHaptics()
        if selectedConcerns.contains(.other) {
            showCustomInput = true
        } else {
            Task { @MainActor in
                await viewModel.updateHealthConcerns(selectedConcerns, modelContext: modelContext)
                dismiss()
            }
        }
    }
}

#Preview {
    HealthConcernsEditView(viewModel: SettingsViewModel())
}
