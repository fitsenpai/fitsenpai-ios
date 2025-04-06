import SwiftUI

struct WorkoutLocationEditView: View {
    @ObservedObject var viewModel: SettingsViewModel
    @State private var selectedLocation: WorkoutLocation
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        _selectedLocation = State(initialValue: viewModel.selectedWorkoutLocation)
    }
    
    var body: some View {
        BaseProfileEditView(
            title: "Workout Location",
            onSave: {
                Task { @MainActor in
                    await viewModel.updateWorkoutLocation(selectedLocation)
                }
            }
        ) {
            SelectableOptionsView(
                options: WorkoutLocation.allCases,
                selection: $selectedLocation,
                iconProvider: { $0.iconName },
                titleProvider: { $0.rawValue }
            )
        }
    }
}

#Preview {
    WorkoutLocationEditView(viewModel: SettingsViewModel())
}
