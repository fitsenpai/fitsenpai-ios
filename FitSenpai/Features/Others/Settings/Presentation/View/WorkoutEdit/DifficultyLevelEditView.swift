import SwiftUI

struct DifficultyLevelEditView: View {
    @ObservedObject var viewModel: SettingsViewModel
    @State private var selectedDifficulty: WorkoutExperience?
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        _selectedDifficulty = State(initialValue: viewModel.selectedWorkoutExperience)
    }
    
    var body: some View {
        BaseProfileEditView(
            title: "Difficulty Level",
            onSave: {
                Task { @MainActor in
                    await viewModel.updateExerciseDifficulty(selectedDifficulty)
                }
            }
        ) {
            SelectableOptionsView(
                options: WorkoutExperience.allCases,
                selection: $selectedDifficulty
            )
        }
    }
}

#Preview {
    DifficultyLevelEditView(viewModel: SettingsViewModel())
}

