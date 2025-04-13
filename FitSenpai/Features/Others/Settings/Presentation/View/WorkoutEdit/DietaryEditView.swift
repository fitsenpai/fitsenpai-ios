import SwiftUI

struct DietaryEditView: View {
    @ObservedObject var viewModel: SettingsViewModel
    @State private var selectedPreference: DietaryPreference
    @State private var showCustomInput: Bool = false
    @Environment(\.dismiss) var dismiss
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        _selectedPreference = State(initialValue: viewModel.selectedDietaryPreference)
    }
    
    var body: some View {
        if showCustomInput {
            OthersInputView(
                title: "Other dietary preference",
                placeholder: "Pescatarian",
                initialValue: viewModel.customDietaryPreference,
                showCustomInput: $showCustomInput,
                onSave: { value in
                    Task { @MainActor in
                        await viewModel.updateDietaryPreference(.other, customValue: value)
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
                            await viewModel.updateDietaryPreference(selectedPreference)
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
                    iconProvider: { $0.iconName },
                    titleProvider: { $0.rawValue },
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
