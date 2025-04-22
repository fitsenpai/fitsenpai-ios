import SwiftUI

struct WorkoutDaysEditView: View {
    @Environment(\.modelContext) private var modelContext

    @ObservedObject var viewModel: SettingsViewModel
    @State private var selectedDays: [WeekDay]
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        // Convert Set<Int> to Set<WeekDay>
        let initialDays = viewModel.profile.workoutDays
        _selectedDays = State(initialValue: initialDays)
    }
    
    var body: some View {
        BaseProfileEditView(
            title: "Workout Days",
            subtitle: "Which days work best for your workouts?",
            onSave: {
                Task { @MainActor in
                    // Convert Set<WeekDay> back to Set<Int>
                    await viewModel.updateWorkoutDays(selectedDays, modelContext: modelContext)
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
