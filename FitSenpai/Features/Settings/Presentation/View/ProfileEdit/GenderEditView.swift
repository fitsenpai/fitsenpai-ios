import SwiftUI

struct GenderEditView: View {
    @ObservedObject var viewModel: SettingsViewModel
    @Environment(\.dismiss) var dismiss
    @State private var selectedGender: Gender
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        _selectedGender = State(initialValue: viewModel.selectedGender)
    }
    
    var body: some View {
        BaseProfileEditView(
            title: "Gender",
            onSave: {
                Task { @MainActor in
                    await viewModel.updateGender(selectedGender)
                }
                dismiss()
            }
        ) {
            SelectableOptionsView(
                options: Gender.allCases,
                selection: $selectedGender,
                iconProvider: { $0.iconName },
                titleProvider: { $0.rawValue }
            )
        }
    }
}
