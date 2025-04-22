import SwiftUI

struct GenderEditView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var viewModel: SettingsViewModel
    @State private var selectedGender: Gender?
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        _selectedGender = State(initialValue: viewModel.profile.gender)
    }
    
    var body: some View {
        BaseProfileEditView(
            title: "Gender",
            onSave: {
                Task { @MainActor in
                    await viewModel.updateGender(selectedGender, modelContext: modelContext)
                }
                dismiss()
            }
        ) {
            SelectableOptionsView(
                options: Gender.allCases,
                selection: $selectedGender
            )
        }
    }
}
