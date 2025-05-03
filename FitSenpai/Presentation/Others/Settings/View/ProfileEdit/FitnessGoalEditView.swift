import SwiftUI

struct FitnessGoalEditView: View {
    @ObservedObject var viewModel: SettingsViewModel
    @Environment(\.dismiss) var dismiss
    @State private var selectedGoal: MainGoalType?
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        _selectedGoal = State(initialValue: MainGoalType(rawValue:viewModel.profile.mainGoal?.id ?? ""))
    }
    
    var body: some View {
        BaseProfileEditView(
            title: "Fitness Goal",
            onSave: {
                Task {
                    await viewModel.updateProfileOption(selectedGoal, for: \.mainGoal)
                }
                dismiss()
            }
        ) {
            SelectableOptionsView(
                options: MainGoalType.allCases,
                selection: $selectedGoal
            )
        }
    }
}

#Preview {
    FitnessGoalEditView(viewModel: SettingsViewModel())
}
