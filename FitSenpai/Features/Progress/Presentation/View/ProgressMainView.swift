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

// MARK: - Subviews
private struct TimeframeSelectorView: View {
    @Binding var selectedTimeframe: ProgressTimeframe
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(ProgressTimeframe.allCases, id: \.self) { timeframe in
                Button {
                    selectedTimeframe = timeframe
                } label: {
                    FSText(
                        text: timeframe.displayText,
                        fontStyle: .bodyBold12,
                        color: selectedTimeframe == timeframe ? .primary : .secondary
                    )
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .frame(maxWidth: .infinity)
                    .background(selectedTimeframe == timeframe ? .white : .gray230)
                    .cornerRadius(5)
                    .padding(3)
                }
                
            }
        }
        .background(Color.gray230)
        .cornerRadius(5)
    }
}

private struct WeightChartCard: View {
    let data: [WeightDataPoint]
    
    var body: some View {
        FSCard(borderColor: Color.gray.opacity(0.2)) {
            VStack(alignment: .leading, spacing: 48) {
                FSText(text: "Your Weight", fontStyle: .medium20)
                
                WeightChartView(data: data)
                    .frame(height: 140)
            }
            .padding(12)
        }
    }
}

private struct WeightUpdatePrompt: View {
    let onUpdateWeight: () -> Void
    
    var body: some View {
        FSCard(backgroundColor: .fsSecondary.opacity(0.7)) {
            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 5) {
                    HStack(spacing: 8) {
                        FSText(text: "Keep going!", fontStyle: .bodyBold14, color: .fsAccentForeground)
                        
                        Image(.iconSparkle)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 18, height: 18)
                            .foregroundStyle(Color.fsAccentForeground)
                    }
                    
                    FSText(text: "Tracking your weight helps\nyou see real progress.", fontStyle: .medium12, color: .black.opacity(0.5))
                }
                
                Spacer()
                FSButton(title: "Update weight", fontStyle: .bodyBold12, letterSpace: 0, cornerRadius: 20, size: .sm, tapAction: onUpdateWeight)
                    .frame(width: 124)
            }
            .padding(4)
        }
    }
}

struct BMISummaryCard: View {
    let bmiValue: Double
    let bmiCategory: BMICategory
    let onInfoTap: () -> Void
    
    var body: some View {
        FSCard(borderColor: Color.gray.opacity(0.2)) {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    FSText(text: "Your BMI", fontStyle: .bodyBold20)
                    Spacer()
                    Button(action: onInfoTap) {
                        Image(systemName: "questionmark.circle")
                            .foregroundColor(.black)
                    }
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack(alignment: .bottom) {
                        Text(String(format: "%.1f", bmiValue))
                            .font(.bodyBold24)
                        
                        
                        Text("Your weight is")
                            .font(.body12)
                            .foregroundColor(.secondary)
                            .fontWeight(.semibold)
                        
                        BMICategoryPill(category: bmiCategory)
                    }
                    
                }
                
                BMIScaleView(bmiValue: bmiValue)
            }
            .padding(12)
        }
    }
}


struct BMICategoryPill: View {
    let category: BMICategory
    
    var body: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(category.color)
                .frame(width: 8, height: 8)
            
            Text(category.rawValue.uppercased())
                .font(.body10)
        }
        .padding(.vertical, 5)
        .padding(.horizontal, 10)
        .background(Color.gray246)
        .clipShape(.rect(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.gray230, lineWidth: 1)
        )
    }
}
