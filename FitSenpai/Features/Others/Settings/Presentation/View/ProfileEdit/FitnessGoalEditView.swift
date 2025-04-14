import SwiftUI

struct FitnessGoalEditView: View {
    @ObservedObject var viewModel: SettingsViewModel
    @Environment(\.dismiss) var dismiss
    @State private var selectedGoal: FitnessGoals?
    
    enum FitnessGoal: String, CaseIterable, Identifiable {
        case fatLoss = "Fat loss"
        case muscleGain = "Muscle gain"
        case generalFitness = "General fitness"
        case increasedEndurance = "Increased endurance"
        case aesthetic = "Aesthetic"
        
        var id: String { rawValue }
        
        var displayTitle: String { rawValue }
        
        var iconName: String {
            switch self {
            case .fatLoss: return "ic_line_chart_down"
            case .muscleGain: return "ic_dumble"
            case .generalFitness: return "ic_sparkle"
            case .increasedEndurance: return "ic_lightning"
            case .aesthetic: return "ic_sparkle"
            }
        }
    }
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        _selectedGoal = State(initialValue: viewModel.selectedFitnessGoal)
    }
    
    var body: some View {
        BaseProfileEditView(
            title: "Fitness Goal",
            onSave: {
                Task { @MainActor in
                    await viewModel.updateFitnessGoal(selectedGoal)
                }
                dismiss()
            }
        ) {
            SelectableOptionsView(
                options: FitnessGoals.allCases,
                selection: $selectedGoal
            )
        }
    }
}

#Preview {
    FitnessGoalEditView(viewModel: SettingsViewModel())
}
