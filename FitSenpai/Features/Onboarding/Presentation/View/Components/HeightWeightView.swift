//
//  HeightWeightView.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/1/25.
//

import SwiftUI

struct HeightWeightView: View {
    @ObservedObject var viewModel: OnboardingMainViewModel
    
    var body: some View {
        VStack(spacing: 24) {
            FSToggle(isOn: $viewModel.isMetric, leftLabel: "Imperial", rightLabel: "Metric")
                .padding()
            
            HStack {
                HeightInputView(height: $viewModel.height, isMetric: viewModel.isMetric)
                Spacer()
                WeightInputView(weight: $viewModel.weight, isMetric: viewModel.isMetric)
            }
        }
    }
}

struct HeightInputView: View {
    @Binding var height: Double
    let isMetric: Bool
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            FSText(text: "Height", fontStyle: .bodyBold16)
            
            if isMetric {
                HStack {
                    Picker("", selection: Binding(
                        get: { Int(height) },
                        set: { height = Double($0) }
                    )) {
                        ForEach(120...220, id: \.self) { cm in
                            HStack {
                                Text("\(cm)").tag(cm)
                                Text("cm")
                            }
                            .font(.custom("PlusJakartaSans-Regular", size: 16))
                            .fontWeight(.medium)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(width: 160)
                    
                }
            } else {
                HStack(spacing: 0) {
                    // Feet
                    HStack {
                        Picker("", selection: Binding(
                            get: { Int(floor(height / 30.48)) },
                            set: { newValue in
                                let inches = height.truncatingRemainder(dividingBy: 30.48) / 2.54
                                height = (Double(newValue) * 30.48) + (inches * 2.54)
                            }
                        )) {
                            ForEach(4...7, id: \.self) { feet in
                                HStack {
                                    Text("\(feet)").tag(feet)
                                    Text("ft")
                                }
                                .font(.custom("PlusJakartaSans-Regular", size: 16))
                                .fontWeight(.medium)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(width: 80)
                    }
                    
                    // Inches
                    HStack {
                        Picker("", selection: Binding(
                            get: { Int((height.truncatingRemainder(dividingBy: 30.48) / 2.54).rounded()) },
                            set: { newValue in
                                let feet = floor(height / 30.48)
                                height = (feet * 30.48) + (Double(newValue) * 2.54)
                            }
                        )) {
                            ForEach(0...11, id: \.self) { inch in
                                HStack {
                                    Text("\(inch)").tag(inch)
                                    Text("in")
                                }
                                .font(.custom("PlusJakartaSans-Regular", size: 16))
                                .fontWeight(.medium)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(width: 80)
                        
                    }
                }
            }
        }
    }
}

struct WeightInputView: View {
    @Binding var weight: Double
    let isMetric: Bool
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            FSText(text: "Weight", fontStyle: .bodyBold16)
            
            HStack {
                Picker("", selection: Binding(
                    get: { Int(weight) },
                    set: { weight = Double($0) }
                )) {
                    ForEach(isMetric ? 40...150 : 88...330, id: \.self) { value in
                        HStack {
                            Text("\(value)").tag(value)
                            Text(isMetric ? "kg" : "lb")
                        }
                        .font(.custom("PlusJakartaSans-Regular", size: 16))
                        .fontWeight(.medium)
                    }
                }
                .pickerStyle(.wheel)
                .frame(width: 150)
            }
        }
    }
}
