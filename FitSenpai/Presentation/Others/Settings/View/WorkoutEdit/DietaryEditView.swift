import SwiftUI

struct DietaryEditView: View {
    @Environment(\.dismiss) var dismiss

    @ObservedObject var viewModel: SettingsViewModel
    @State private var selectedPreference: DietPreferenceType?
    @State private var showCustomInput: Bool = false
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        _selectedPreference = State(initialValue: DietPreferenceType(rawValue: viewModel.profile.dietPreference?.id ?? ""))
    }
    
    var body: some View {
        if showCustomInput {
            OthersInputView(
                title: "Other dietary preference",
                placeholder: "Pescatarian",
                initialValue: viewModel.profile.otherDietPreference ?? "",
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
                    options: DietPreferenceType.allCases,
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
