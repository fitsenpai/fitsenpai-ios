import SwiftUI

struct GenderEditView: View {
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var viewModel: SettingsViewModel
    @State private var selectedGender: Gender?
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        _selectedGender = State(initialValue: Gender(rawValue: viewModel.profile.gender?.id ?? ""))
    }
    
    var body: some View {
        BaseProfileEditView(
            title: "Gender",
            onSave: {
                Task {
                    await viewModel.updateProfileOption(selectedGender, for: \.gender)
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
