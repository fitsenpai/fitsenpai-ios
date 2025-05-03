import SwiftUI

struct HealthConcernsEditView: View {

    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: SettingsViewModel
    @State private var selectedConcerns: [HealthConcernType]
    @State private var showCustomInput: Bool = false
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        _selectedConcerns = State(initialValue: viewModel.profile.healthConcerns.compactMap({ HealthConcernType(rawValue: $0.id) }))

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
            initialValue: viewModel.profile.otherHealthConcern ?? "",
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
            options: HealthConcernType.allCases,
            isMultiSelect: true,
            selection: .constant(HealthConcernType.none),
            selections: $selectedConcerns,
            showCustomInput: $showCustomInput,
            isOtherOption: { $0 == .other },
            isNoneOption: { $0 == .none }
        )
    }
    
    private func handleCustomInput(_ value: String) {
        triggerHaptics()
        // When saving custom input, clear other selections and only keep "Other"
        Task {
            await viewModel.updateHealthConcerns([.other], customValue: value)
            dismiss()
        }
    }
    
    private func handleSave() {
        triggerHaptics()
        if selectedConcerns.contains(.other) {
            showCustomInput = true
        } else {
            Task { @MainActor in
                await viewModel.updateHealthConcerns(selectedConcerns)
                dismiss()
            }
        }
    }
}

#Preview {
    HealthConcernsEditView(viewModel: SettingsViewModel())
}
