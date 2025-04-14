import SwiftUI

struct WorkoutDaysEditView: View {
    @ObservedObject var viewModel: SettingsViewModel
    @State private var selectedDays: [WeekDay]
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        // Convert Set<Int> to Set<WeekDay>
        let initialDays = viewModel.workoutDays
        _selectedDays = State(initialValue: initialDays)
    }
    
    var body: some View {
        BaseProfileEditView(
            title: "Workout Days",
            subtitle: "Which days work best for your workouts?",
            onSave: {
                Task { @MainActor in
                    // Convert Set<WeekDay> back to Set<Int>
                    await viewModel.updateWorkoutDays(selectedDays)
                }
            }
        ) {
            MultiSelectableOptionsView<WeekDay>(
                options: WeekDay.allCases,
                selections: $selectedDays
            )
        }
    }
}

#Preview {
    WorkoutDaysEditView(viewModel: SettingsViewModel())
}
