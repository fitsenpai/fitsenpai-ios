import SwiftUI

struct ActivityLevelEditView: View {
    @ObservedObject var viewModel: SettingsViewModel
    @Environment(\.dismiss) var dismiss
    @State private var selectedLevel: ActivityLevel?
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        _selectedLevel = State(initialValue: ActivityLevel(rawValue: viewModel.profile.activityLevel?.id ?? ""))
    }
    
    var body: some View {
        BaseProfileEditView(
            title: "Activity Level",
            onSave: {
                Task {
                    await viewModel.updateProfileOption(selectedLevel, for: \.activityLevel)
                }
                dismiss()
            }
        ) {
            SelectableOptionsView(
                options: ActivityLevel.allCases,
                selection: $selectedLevel
            )
        }
    }
}

#Preview {
    ActivityLevelEditView(viewModel: SettingsViewModel())
}
