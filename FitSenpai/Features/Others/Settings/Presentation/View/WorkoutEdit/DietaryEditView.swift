import SwiftUI

struct DietaryEditView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss

    @ObservedObject var viewModel: SettingsViewModel
    @State private var selectedPreference: DietaryPreference?
    @State private var showCustomInput: Bool = false
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        _selectedPreference = State(initialValue: viewModel.profile.diet)
    }
    
    var body: some View {
        if showCustomInput {
            OthersInputView(
                title: "Other dietary preference",
                placeholder: "Pescatarian",
                initialValue: viewModel.profile.otherDiet ?? "",
                showCustomInput: $showCustomInput,
                onSave: { value in
                    Task { @MainActor in
                        await viewModel.updateDietaryPreference(.other, customValue: value, modelContext: modelContext)
                        dismiss()
                    }
                }
            )
        } else {
            BaseProfileEditView(
                title: "Dietary Preference",
                onSave: {
                    if selectedPreference == .other {
                        showCustomInput = true
                    } else {
                        Task { @MainActor in
                            await viewModel.updateDietaryPreference(selectedPreference, modelContext: modelContext)
                            dismiss()
                        }
                    }
                }
            ) {
                RestrictionsOptionsView(
                    title: "Dietary Preference",
                    options: DietaryPreference.allCases,
                    isMultiSelect: false,
                    selection: $selectedPreference,
                    selections: .constant([]), // Unused for single select
                    showCustomInput: $showCustomInput,
                    isOtherOption: { $0 == .other },
                    isNoneOption: { $0 == .none }
                )
            }
        }
    }
}

#Preview {
    DietaryEditView(viewModel: SettingsViewModel())
}
