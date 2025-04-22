import SwiftUI

struct WorkoutDurationEditView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var viewModel: SettingsViewModel
    @State private var selectedDuration: WorkoutDuration?
    

    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        _selectedDuration = State(initialValue: viewModel.profile.workoutDuration)
    }
    
    var body: some View {
        BaseProfileEditView(
            title: "Workout Duration",
            onSave: {
                Task { @MainActor in
                    await viewModel.updateWorkoutDuration(selectedDuration, modelContext: modelContext)
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
