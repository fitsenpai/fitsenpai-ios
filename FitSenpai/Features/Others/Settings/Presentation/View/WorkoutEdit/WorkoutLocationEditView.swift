import SwiftUI

struct WorkoutLocationEditView: View {
    @Environment(\.modelContext) private var modelContext

    @ObservedObject var viewModel: SettingsViewModel
    @State private var selectedLocation: WorkoutLocation?
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        _selectedLocation = State(initialValue: viewModel.profile.workoutLocation)
    }
    
    var body: some View {
        BaseProfileEditView(
            title: "Workout Location",
            onSave: {
                Task { @MainActor in
                    await viewModel.updateWorkoutLocation(selectedLocation, modelContext: modelContext)
                }
            }
        ) {
            SelectableOptionsView(
                options: WorkoutLocation.allCases,
                selection: $selectedLocation
            )
        }
    }
}

#Preview {
    WorkoutLocationEditView(viewModel: SettingsViewModel())
}
