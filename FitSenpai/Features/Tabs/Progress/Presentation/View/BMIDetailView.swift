import SwiftUI

struct BMIDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: BMIDetailViewModel
    
    private let categories = [
        ("UNDERWEIGHT", Color.blue),
        ("NORMAL", Color.green),
        ("OVERWEIGHT", Color.orange),
        ("OBESE", Color.red)
    ]
    
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                bmiView
                disclaimerView
                whyBMIView
                sourceLinkButton
            }
            .padding(24)
        }
        .sheet(isPresented: $viewModel.showBrowser) {
            if let url = URL(string: "https://www.cdc.gov/bmi/about/index.html") {
                SafariView(url: url)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.black)
                        .frame(width: 24, height: 24)
                        .padding(10)
                        .background(Circle().fill(Color.gray246))
                }
            }
        }
    }
    
    var bmiView: some View {
        // BMI Value and Scale
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                FSText(text: "Your BMI", fontStyle: .bodyBold20)
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .bottom) {
                    Text(String(format: "%.1f", viewModel.bmi))
                        .font(.bodyBold24)
                    
                    
                    Text("Your weight is")
                        .font(.body12)
                        .foregroundColor(.secondary)
                        .fontWeight(.semibold)
                    
                    BMICategoryPill(category: viewModel.bmiCategory)
                }
                
            }
            
            BMIScaleView(bmiValue: viewModel.bmi)
            
            // BMI Categories
            HStack {
                ForEach(categories, id: \.0) { category in
                    HStack(spacing: 4) {
                        Circle()
                            .fill(category.1)
                            .frame(width: 8, height: 8)
                        Text(category.0)
                            .font(.body10)
                            .foregroundColor(.secondary)
                    }
                    if category.0 != categories.last?.0 {
                        Spacer()
                    }
                }
            }
        }
        .padding(.top, 5)
    }
    
    var disclaimerView: some View {
        // Disclaimer
        VStack(alignment: .leading, spacing: 12) {
            Text("Disclaimer")
                .font(.bodyBold16)
            FSText(text: viewModel.disclaimerText, fontStyle: .body14, lineSpacing: 6)
        }
    }
    
    var whyBMIView: some View {
        // Why BMI Matters
        VStack(alignment: .leading, spacing: 12) {
            Text("Why does BMI matter?")
                .font(.bodyBold16)
            
            FSText(text: viewModel.whyBMIMattersText, fontStyle: .body14, lineSpacing: 6)
            
            VStack(alignment: .leading, spacing: 8) {
                ForEach(viewModel.healthRisks, id: \.self) { condition in
                    HStack(alignment: .top, spacing: 8) {
                        Text("•")
                            .bold()
                        FSText(text: condition, fontStyle: .body14)
                    }
                }
            }
            .padding(.leading, 4)
        }
    }
    
    var sourceLinkButton: some View {
        Button {
            viewModel.openSource()
        } label: {
            FSText(text: "Source", fontStyle: .bodyBold14, letterSpace: 0, color: Color.fsMutedForeground, isUnderlined: true)
        }

    }
}

