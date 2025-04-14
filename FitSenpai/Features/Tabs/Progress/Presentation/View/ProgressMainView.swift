import SwiftUI
import SuperwallKit

struct ProgressMainView: View {
    @StateObject private var viewModel = ProgressViewModel()
    @AppState(\.isLimited) private var isLimitedAccess: Bool

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 24) {
                FSTextView("Progress", typography: .h3)
                TimeframeSelectorView(selectedTimeframe: $viewModel.selectedTimeframe)
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        WeightChartCard(data: viewModel.weightData)
                        if isLimitedAccess {
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
        Superwall.shared.register(placement: "campaign_trigger")
    }
}
