import SwiftUI

struct WorkoutDurationEditView: View {
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var viewModel: SettingsViewModel
    @State private var selectedDuration: WorkoutDurationType?
    

    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        _selectedDuration = State(initialValue: WorkoutDurationType(rawValue: viewModel.profile.workoutDuration?.id ?? ""))
    }
    
    var body: some View {
        BaseProfileEditView(
            title: "Workout Duration",
            onSave: {
                Task { 
                    await viewModel.updateProfileOption(selectedDuration, for: \.workoutDuration)
                }
            }
        ) {
            SelectableOptionsView(
                options: WorkoutDurationType.allCases,
                selection: $selectedDuration
            )
        }
    }
}

#Preview {
    WorkoutDurationEditView(viewModel: SettingsViewModel())
}
