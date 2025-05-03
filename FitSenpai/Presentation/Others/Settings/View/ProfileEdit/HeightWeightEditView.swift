import SwiftUI

struct HeightWeightEditView: View {

    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: SettingsViewModel
    @State private var isMetric: Bool
    @State private var height: Double
    @State private var weight: Double
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        let systemOfMeasurement = MeasurementType(rawValue: viewModel.profile.systemOfMeasurement?.id ?? "") ?? .imperial
        _isMetric = State(initialValue: systemOfMeasurement == .metric)
        _height = State(initialValue: Double(viewModel.profile.height ?? 0))
        _weight = State(initialValue: Double(viewModel.profile.weight ?? 0))
    }
    
    var body: some View {
        BaseProfileEditView(
            title: "Height & Weight",
            onSave: {
                let measurement: MeasurementType = isMetric ? .metric : .imperial
                Task {
                    await viewModel.updateHeightWeight(
                        height: height,
                        weight: weight,
                        measurement: measurement
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
