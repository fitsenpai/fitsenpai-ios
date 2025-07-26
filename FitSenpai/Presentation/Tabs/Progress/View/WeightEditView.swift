//
//  WeightEditView.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/9/25.
//

import SwiftUI

struct WeightEditView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: ProgressViewModel
    @State private var isMetric: Bool
    @State private var weight: Double
    
    init(viewModel: ProgressViewModel) {
        self.viewModel = viewModel
        _isMetric = State(initialValue: viewModel.isMetric)
        _weight = State(initialValue: viewModel.weight)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 40) {
            FSText(text: "Update Weight", fontStyle: .bodyBold28)
                .padding(.top, 12)
            
            VStack(spacing: 40) {
                FSToggle(isOn: $isMetric, leftLabel: "Imperial", rightLabel: "Metric")
                    .padding()
                WeightInputView(title: "Current Weight",weight: $weight, isMetric: isMetric)
            }
            .frame(maxWidth: .infinity)
            
            Spacer()
            
            FSButton(title: "Save changes", fontStyle: .bodyBold16, cornerRadius: 32) {
                Task {
                    await viewModel.createWeigths(weight: weight)
                    dismiss()
                }
            }
        }
        .padding(24)
        .navigationBarBackButtonHidden()
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
        .loadingOverlay(state: $viewModel.viewState)
    }
}
