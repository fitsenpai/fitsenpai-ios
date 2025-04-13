import SwiftUI
import SuperwallKit

struct ProgressMainView: View {
    @StateObject private var viewModel = ProgressViewModel()
    @AppState(\.isLimited) private var isLimitedAccess: Bool

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 24) {
                FSText(text: "Progress", fontStyle: .heading24)
                TimeframeSelectorView(selectedTimeframe: $viewModel.selectedTimeframe)
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        WeightChartCard(data: viewModel.weightData)
                        if isLimitedAccess {
                            WeightUpdatePrompt(
                                title: "Upgrade to Pro",
                                subtitle: "Unlock all workouts and meals\nfor the entire week.",
                                icon: .iconCrownGreen,
                                buttonText: "Try for $0",
                                onButtonTap: onTryForFreeTapped
                            )
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
            .navigationDestination(isPresented: $viewModel.showUpdateWeight, destination: {
                WeightEditView(viewModel: viewModel)
                    .navigationBarBackButtonHidden()
            })
        }
    }
    
    func onTryForFreeTapped() {
        Superwall.shared.register(placement: "campaign_trigger")
    }
}
