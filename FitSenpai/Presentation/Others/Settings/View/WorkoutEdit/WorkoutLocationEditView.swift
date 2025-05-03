import SwiftUI

struct WorkoutLocationEditView: View {

    @ObservedObject var viewModel: SettingsViewModel
    @State private var selectedLocation: WorkoutLocationType?
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        _selectedLocation = State(initialValue: WorkoutLocationType(rawValue: viewModel.profile.workoutLocation?.id ?? ""))
    }
    
    var body: some View {
        BaseProfileEditView(
            title: "Workout Location",
            onSave: {
                Task {
                    await viewModel.updateProfileOption(selectedLocation, for: \.workoutLocation)
                }
            }
        ) {
            SelectableOptionsView(
                options: WorkoutLocationType.allCases,
                selection: $selectedLocation
            )
        }
    }
}

#Preview {
    WorkoutLocationEditView(viewModel: SettingsViewModel())
}
