import SwiftUI

struct DifficultyLevelEditView: View {
    
    @ObservedObject var viewModel: SettingsViewModel
    @State private var selectedDifficulty: WorkoutExperienceType?
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        _selectedDifficulty = State(initialValue: WorkoutExperienceType(rawValue: viewModel.profile.workoutExperience?.id ?? ""))
    }
    
    var body: some View {
        BaseProfileEditView(
            title: "Difficulty Level",
            onSave: {
                Task {
                    await viewModel.updateProfileOption(selectedDifficulty, for: \.workoutExperience)
                }
            }
        ) {
            SelectableOptionsView(
                options: WorkoutExperienceType.allCases,
                selection: $selectedDifficulty
            )
        }
    }
}

#Preview {
    DifficultyLevelEditView(viewModel: SettingsViewModel())
}

