import SwiftUI

struct ActivityLevelEditView: View {
    @Environment(\.modelContext) private var modelContext
    @ObservedObject var viewModel: SettingsViewModel
    @Environment(\.dismiss) var dismiss
    @State private var selectedLevel: ActivityLevel?
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        _selectedLevel = State(initialValue: viewModel.profile.activityLevel)
    }
    
    var body: some View {
        BaseProfileEditView(
            title: "Activity Level",
            onSave: {
                Task { @MainActor in
                    await viewModel.updateActivityLevel(selectedLevel, modelContext: modelContext)
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
