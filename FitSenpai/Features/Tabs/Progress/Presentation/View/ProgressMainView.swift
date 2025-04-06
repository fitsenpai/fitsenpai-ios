import SwiftUI

struct ProgressMainView: View {
    @StateObject private var viewModel = ProgressViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 24) {
                FSText(text: "Progress", fontStyle: .heading24)
                TimeframeSelectorView(selectedTimeframe: $viewModel.selectedTimeframe)
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        WeightChartCard(data: viewModel.weightData)
                        WeightUpdatePrompt(onUpdateWeight: viewModel.updateWeight)
                        BMISummaryCard(
                            bmiValue: viewModel.bmiValue,
                            bmiCategory: viewModel.bmiCategory,
                            onInfoTap: { viewModel.showBMIDetail = true }
                        )
                    }
                }
            }
            .padding()
            .navigationDestination(isPresented: $viewModel.showBMIDetail, destination: {
                BMIDetailView(viewModel: BMIDetailViewModel(bmi: viewModel.bmiValue))
                    .navigationBarBackButtonHidden()
            })
        }
    }
}
