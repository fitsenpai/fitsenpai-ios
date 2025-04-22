import SwiftUI

struct HeightWeightEditView: View {
    @Environment(\.modelContext) private var modelContext

    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: SettingsViewModel
    @State private var isMetric: Bool
    @State private var height: Double
    @State private var weight: Double
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        _isMetric = State(initialValue: viewModel.profile.isMetric)
        _height = State(initialValue: viewModel.profile.height ?? 0)
        _weight = State(initialValue: viewModel.profile.weight ?? 0)
    }
    
    var body: some View {
        BaseProfileEditView(
            title: "Height & Weight",
            onSave: {
                Task { @MainActor in
                    await viewModel.updateHeightWeight(
                        height: height,
                        weight: weight,
                        isMetric: isMetric,
                        modelContext: modelContext
                    )
                }
            },
            onBack: { dismiss() }
        ) {
            VStack(spacing: 24) {
                FSToggle(isOn: $isMetric, leftLabel: "Imperial", rightLabel: "Metric")
                    .padding()
                
                HStack {
                    HeightInputView(height: $height, isMetric: isMetric)
                    Spacer()
                    WeightInputView(weight: $weight, isMetric: isMetric)
                }
            }
        }
    }
}
