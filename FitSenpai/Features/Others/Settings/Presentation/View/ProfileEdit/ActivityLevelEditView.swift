import SwiftUI

struct ActivityLevelEditView: View {
    @ObservedObject var viewModel: SettingsViewModel
    @Environment(\.dismiss) var dismiss
    @State private var selectedLevel: ActivityLevel
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        _selectedLevel = State(initialValue: viewModel.selectedActivityLevel)
    }
    
    var body: some View {
        BaseProfileEditView(
            title: "Activity Level",
            onSave: {
                Task { @MainActor in
                    await viewModel.updateActivityLevel(selectedLevel)
                }
                dismiss()
            }
        ) {
            SelectableOptionsView(
                options: ActivityLevel.allCases,
                selection: $selectedLevel,
                iconProvider: { $0.iconName },
                titleProvider: { $0.rawValue }
            )
        }
    }
}

#Preview {
    ActivityLevelEditView(viewModel: SettingsViewModel())
}
