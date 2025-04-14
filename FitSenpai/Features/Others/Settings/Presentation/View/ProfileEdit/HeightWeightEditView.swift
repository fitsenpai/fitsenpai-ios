import SwiftUI

struct HeightWeightEditView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: SettingsViewModel
    @State private var isMetric: Bool
    @State private var height: Double
    @State private var weight: Double
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        _isMetric = State(initialValue: viewModel.isMetric)
        _height = State(initialValue: viewModel.height)
        _weight = State(initialValue: viewModel.weight)
    }
    
    var body: some View {
        BaseProfileEditView(
            title: "Height & Weight",
            onSave: {
                Task { @MainActor in
                    await viewModel.updateHeightWeight(
                        height: height,
                        weight: weight,
                        isMetric: isMetric
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
