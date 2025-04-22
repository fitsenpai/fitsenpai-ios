import SwiftUI

struct DifficultyLevelEditView: View {
    @Environment(\.modelContext) private var modelContext
    
    @ObservedObject var viewModel: SettingsViewModel
    @State private var selectedDifficulty: WorkoutExperience?
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        _selectedDifficulty = State(initialValue: viewModel.profile.workoutExperience)
    }
    
    var body: some View {
        BaseProfileEditView(
            title: "Difficulty Level",
            onSave: {
                Task { @MainActor in
                    await viewModel.updateExerciseDifficulty(selectedDifficulty, modelContext: modelContext)
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

