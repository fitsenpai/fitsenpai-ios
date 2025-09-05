//
//  HeightWeightView.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/1/25.
//

import SwiftUI

struct HeightWeightView: View {
    @ObservedObject var viewModel: CreateProfileViewModel
    
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
    @Binding var height: Double  // Always in cm
    let isMetric: Bool
    
    // Display ranges for metric (122 cm to 241 cm covers 4'0" to 7'11")
    var cmRange: ClosedRange<Int> {
        122...241
    }

    // Display ranges for imperial
    var feetRange: ClosedRange<Int> {
        4...7
    }

    var inchRange: ClosedRange<Int> {
        0...11
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            FSText(text: "Height", fontStyle: .bodyBold16)
            
            if isMetric {
                HStack {
                    Picker("", selection: Binding(
                        get: { Int(height) },
                        set: { height = Double($0) }
                    )) {
                        ForEach(cmRange, id: \.self) { cm in
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
                            get: { 
                                let totalInches = height / 2.54
                                return Int(totalInches / 12)
                            },
                            set: { newValue in
                                let currentInches = (height / 2.54).truncatingRemainder(dividingBy: 12)
                                let totalInches = Double(newValue) * 12 + currentInches
                                height = totalInches * 2.54  // Convert back to cm
                            }
                        )) {
                            ForEach(feetRange, id: \.self) { feet in
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
                            get: { 
                                let totalInches = height / 2.54
                                return Int(totalInches.truncatingRemainder(dividingBy: 12).rounded())
                            },
                            set: { newValue in
                                let currentFeet = Int((height / 2.54) / 12)
                                let totalInches = Double(currentFeet) * 12 + Double(newValue)
                                height = totalInches * 2.54  // Convert back to cm
                            }
                        )) {
                            ForEach(inchRange, id: \.self) { inch in
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
    var title: String = "Weight"
    @Binding var weight: Double  // Always in kg
    let isMetric: Bool
    
    // Display ranges for metric
    var kgRange: ClosedRange<Int> {
        40...150
    }

    // Display ranges for imperial (90 lbs to 330 lbs)
    var lbRange: ClosedRange<Int> {
        90...330
    }

    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            FSText(text: title, fontStyle: .bodyBold16)
            
            if isMetric {
                HStack {
                    Picker("", selection: Binding(
                        get: { Int(weight) },
                        set: { weight = Double($0) }
                    )) {
                        ForEach(kgRange, id: \.self) { value in
                            HStack {
                                Text("\(value)").tag(value)
                                Text("kg")
                            }
                            .font(.custom("PlusJakartaSans-Regular", size: 16))
                            .fontWeight(.medium)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(width: 150)
                }
            } else {
                HStack {
                    Picker("", selection: Binding(
                        get: { Int(weight * 2.20462) },  // Convert kg to lbs for display
                        set: { weight = Double($0) / 2.20462 }  // Convert lbs back to kg
                    )) {
                        ForEach(lbRange, id: \.self) { value in
                            HStack {
                                Text("\(value)").tag(value)
                                Text("lb")
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
}