import SwiftUI

struct DifficultyLevelEditView: View {
    @ObservedObject var viewModel: SettingsViewModel
    @State private var selectedDifficulty: ExerciseDifficulty
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        _selectedDifficulty = State(initialValue: viewModel.selectedExerciseDifficulty)
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
                options: ExerciseDifficulty.allCases,
                selection: $selectedDifficulty,
                iconProvider: { $0.iconName },
                titleProvider: { $0.rawValue }
            )
        }
    }
}

#Preview {
    DifficultyLevelEditView(viewModel: SettingsViewModel())
}

