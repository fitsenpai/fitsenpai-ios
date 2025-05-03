import SwiftUI

struct WorkoutDaysEditView: View {

    @ObservedObject var viewModel: SettingsViewModel
    @State private var selectedDays: [WeekDayType]
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        // Convert Set<Int> to Set<WeekDay>
        let initialDays = viewModel.profile.workoutDays
        _selectedDays = State(initialValue: initialDays.compactMap { WeekDayType(rawValue: $0.id) })
    }
    
    var body: some View {
        BaseProfileEditView(
            title: "Workout Days",
            subtitle: "Which days work best for your workouts?",
            onSave: {
                Task {
                    await viewModel.updateProfileOption(selectedDays, for: \.workoutDays)
                }
            }
        ) {
            MultiSelectableOptionsView<WeekDayType>(
                options: WeekDayType.allCases,
                selections: $selectedDays
            )
        }
    }
}

#Preview {
    WorkoutDaysEditView(viewModel: SettingsViewModel())
}
