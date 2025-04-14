import SwiftUI

struct WorkoutDurationEditView: View {
    @ObservedObject var viewModel: SettingsViewModel
    @State private var selectedDuration: WorkoutDuration?
    @Environment(\.dismiss) var dismiss

    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        _selectedDuration = State(initialValue: viewModel.selectedWorkoutDuration)
    }
    
    var body: some View {
        BaseProfileEditView(
            title: "Workout Duration",
            onSave: {
                Task { @MainActor in
                    await viewModel.updateWorkoutDuration(selectedDuration)
                }
            }
        ) {
            SelectableOptionsView(
                options: WorkoutDuration.allCases,
                selection: $selectedDuration
            )
        }
    }
}

#Preview {
    WorkoutDurationEditView(viewModel: SettingsViewModel())
}
