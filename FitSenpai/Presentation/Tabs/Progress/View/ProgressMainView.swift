import SwiftUI

struct ProgressMainView: View {
    @EnvironmentObject private var superwall: SuperwallManager
    @StateObject private var viewModel = ProgressViewModel()

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 24) {
                FSTextView("Progress", typography: .h3)
                TimeframeSelectorView(selectedTimeframe: $viewModel.selectedTimeframe)
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        WeightChartCard(data: viewModel.weightData)
                        if superwall.isFirstDayTrialActive {
                            UpgrageCardView {
                                onTryForFreeTapped()
                            }
                        } else {
                            WeightUpdatePrompt(
                                title: "Keep going!",
                                subtitle: "Tracking your weight helps\nyou see real progress.",
                                icon: .iconSparkle,
                                buttonText: "Update weight",
                                onButtonTap: viewModel.updateWeight
                            )
                        }
                       
                        BMISummaryCard(
                            bmiValue: viewModel.bmiValue,
                            bmiCategory: viewModel.bmiCategory,
                            onInfoTap: {
                                triggerHaptics()
                                viewModel.showBMIDetail = true
                            }
                        )
                    }
                }
            }
            .padding()
            .navigationDestination(isPresented: $viewModel.showBMIDetail, destination: {
                BMIDetailView(viewModel: BMIDetailViewModel(bmi: viewModel.bmiValue))
                    .navigationBarBackButtonHidden()
            })
            .navigationDestination(isPresented: $viewModel.showUpdateWeight, destination: {
                WeightEditView(viewModel: viewModel)
                    .navigationBarBackButtonHidden()
            })
        }
    }
    
    func onTryForFreeTapped() {
        triggerHaptics()
        superwall.presentPaywall(for: .proContent)
    }
}
