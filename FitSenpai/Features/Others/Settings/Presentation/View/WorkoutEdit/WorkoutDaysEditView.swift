import SwiftUI

struct WorkoutDaysEditView: View {
    @ObservedObject var viewModel: SettingsViewModel
    @State private var selectedDays: Set<WeekDay>
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        // Convert Set<Int> to Set<WeekDay>
        let initialDays = Set(viewModel.workoutDays.map { WeekDay(rawValue: $0) ?? .monday })
        _selectedDays = State(initialValue: initialDays)
    }
    
    var body: some View {
        BaseProfileEditView(
            title: "Workout Days",
            subtitle: "Which days work best for your workouts?",
            onSave: {
                Task { @MainActor in
                    // Convert Set<WeekDay> back to Set<Int>
                    await viewModel.updateWorkoutDays(Set(selectedDays.map { $0.rawValue }))
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
