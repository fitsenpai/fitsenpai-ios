//
//  OnboardingView.swift
//  FitSenpai
//
//  Created by Kevin M on 3/17/25.
//

import SwiftUI

struct OnboardingMainView: View {
    @StateObject private var viewModel = OnboardingMainViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                // Custom Header
                HStack {
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            if viewModel.currentStepIndex > 0 {
                                viewModel.moveToPreviousStep()
                            } else {
                                dismiss()
                            }
                        }
                    }) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.black)
                            .frame(width: 24, height: 24)
                    }
                    
                    Spacer()
                }
                .padding(.vertical, 8)
                
                // Title Section
                VStack(alignment: .leading, spacing: 8) {
                    Text(viewModel.currentStep.title)
                        .font(.system(size: 28, weight: .bold))
                        .multilineTextAlignment(.leading)
                        .transition(.opacity.combined(with: .move(edge: .leading)))
                    
                    if let subtitle = viewModel.currentStep.subtitle {
                        Text(subtitle)
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.leading)
                            .transition(.opacity.combined(with: .move(edge: .leading)))
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .animation(.easeInOut(duration: 0.3), value: viewModel.currentStep.title)
                
                // Dynamic Content
                Group {
                    contentForStep
                        .transition(.opacity.combined(with: .move(edge: .trailing)))
                }
                .animation(.easeInOut(duration: 0.3), value: viewModel.currentStepIndex)
                
                Spacer()
                
                // Action Button
                if viewModel.currentStep.showsButton {
                    FSButton(
                        title: "Continue",
                        fontStyle: .system(size: 17, weight: .semibold),
                        background: viewModel.canProceed ? .fsPrimary : .gray.opacity(0.3)
                    ) {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            if viewModel.canProceed {
                                viewModel.moveToNextStep()
                            }
                        }
                    }
                    .disabled(!viewModel.canProceed)
                }
            }
            .padding(.horizontal, 24)
            .sheet(isPresented: $viewModel.showOtherInput) {
                OtherInputView(viewModel: viewModel)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarHidden(true)
    }
    
    @ViewBuilder
    private var contentForStep: some View {
        if viewModel.currentStep.isHeightWeightStep {
            HeightWeightView(viewModel: viewModel)
        } else if viewModel.currentStep.isAgeStep {
            AgeInputView(viewModel: viewModel)
        } else if viewModel.currentStep.isMacroStep {
            MacroBreakdownView(
                calories: viewModel.macroCalories,
                protein: viewModel.macroProtein,
                carbs: viewModel.macroCarbs,
                fat: viewModel.macroFat
            )
        } else if viewModel.currentStep.isTestimonialStep {
            OnboardingTestimonialView()
        } else if viewModel.currentStep.showsButton {
            MultipleSelectionListView(
                items: viewModel.currentStep.options,
                selectedItems: $viewModel.selectedOptions,
                onSelection: viewModel.handleMultipleSelection
            )
        } else {
            SingleSelectionListView(
                items: viewModel.currentStep.options,
                selectedItems: $viewModel.selectedOptions,
                onSelection: viewModel.handleSingleSelection,
                viewModel: viewModel
            )
        }
    }
}

// MARK: - Supporting Views
struct HeightWeightView: View {
    @ObservedObject var viewModel: OnboardingMainViewModel
    
    var body: some View {
        VStack(spacing: 24) {
            // Imperial/Metric Toggle
            HStack {
                Text("Imperial")
                Toggle("", isOn: $viewModel.isMetric)
                Text("Metric")
            }
            .padding()
            
            // Height Input
            HeightInputView(height: $viewModel.height, isMetric: viewModel.isMetric)
            
            // Weight Input
            WeightInputView(weight: $viewModel.weight, isMetric: viewModel.isMetric)
        }
    }
}

struct HeightInputView: View {
    @Binding var height: Double
    let isMetric: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Height")
                .font(.system(size: 16, weight: .medium))
            
            if isMetric {
                HStack {
                    TextField("", value: $height, formatter: NumberFormatter())
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Text("cm")
                }
            } else {
                HStack(spacing: 12) {
                    // Feet
                    HStack {
                        TextField("", value: Binding(
                            get: { floor(height / 30.48) },
                            set: { newValue in
                                let inches = height.truncatingRemainder(dividingBy: 30.48) / 2.54
                                height = (newValue * 30.48) + (inches * 2.54)
                            }
                        ), formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 60)
                        Text("ft")
                    }
                    
                    // Inches
                    HStack {
                        TextField("", value: Binding(
                            get: { (height.truncatingRemainder(dividingBy: 30.48) / 2.54).rounded() },
                            set: { newValue in
                                let feet = floor(height / 30.48)
                                height = (feet * 30.48) + (newValue * 2.54)
                            }
                        ), formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 60)
                        Text("in")
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
        VStack(alignment: .leading, spacing: 8) {
            Text("Weight")
                .font(.system(size: 16, weight: .medium))
            
            HStack {
                TextField("", value: $weight, formatter: NumberFormatter())
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 100)
                Text(isMetric ? "kg" : "lb")
            }
        }
    }
}

struct AgeInputView: View {
    @ObservedObject var viewModel: OnboardingMainViewModel
    
    var body: some View {
        VStack {
            TextField("", value: $viewModel.age, formatter: NumberFormatter())
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 100)
        }
    }
}

struct MacroBreakdownView: View {
    let calories: Int
    let protein: Int
    let carbs: Int
    let fat: Int
    
    var body: some View {
        VStack(spacing: 16) {
            MacroRow(value: "\(calories)", label: "Calories", color: .green)
            MacroRow(value: "\(protein)g", label: "Protein", color: .orange)
            MacroRow(value: "\(carbs)g", label: "Carbs", color: .blue)
            MacroRow(value: "\(fat)g", label: "Fat", color: .purple)
        }
    }
}

struct MacroRow: View {
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        HStack {
            Text(value)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(color)
            Text(label)
                .font(.system(size: 16))
                .foregroundColor(.gray)
        }
    }
}

struct OnboardingTestimonialView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image("testimonial_image")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(12)
            
            HStack {
                ForEach(0..<5) { _ in
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                }
            }
        }
    }
}

struct OtherInputView: View {
    @ObservedObject var viewModel: OnboardingMainViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                TextField("", text: $viewModel.otherInputText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .placeholder(when: viewModel.otherInputText.isEmpty) {
                        Text(viewModel.otherInputPlaceholder)
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal)
                    .font(.system(size: 16))
                
                Spacer()
                
                FSButton(
                    title: "Save",
                    fontStyle: .system(size: 17, weight: .semibold),
                    background: viewModel.otherInputText.isEmpty ? .gray.opacity(0.3) : .fsPrimary
                ) {
                    viewModel.submitOtherInput()
                }
                .disabled(viewModel.otherInputText.isEmpty)
                .padding(.bottom, 24)
            }
            .padding(.top, 24)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(viewModel.otherInputTitle)
            .navigationBarItems(
                leading: Button(action: { dismiss() }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.black)
                }
            )
        }
    }
}

// MARK: - Selection Views
struct SingleSelectionListView: View {
    let items: [SelectionItem]
    @Binding var selectedItems: Set<String>
    let onSelection: (SelectionItem) -> Void
    @ObservedObject var viewModel: OnboardingMainViewModel
    
    var body: some View {
        VStack(spacing: 12) {
            ForEach(items) { item in
                SelectionItemView(
                    item: item,
                    isSelected: selectedItems.contains(item.id),
                    isDisabled: viewModel.isSelectionInProgress,
                    action: {
                        onSelection(item)
                    }
                )
            }
        }
    }
}

struct MultipleSelectionListView: View {
    let items: [SelectionItem]
    @Binding var selectedItems: Set<String>
    let onSelection: (SelectionItem) -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            ForEach(items) { item in
                SelectionItemView(
                    item: item,
                    isSelected: selectedItems.contains(item.id),
                    isDisabled: false,
                    action: {
                        onSelection(item)
                    }
                )
            }
        }
    }
}

struct SelectionItemView: View {
    let item: SelectionItem
    let isSelected: Bool
    let isDisabled: Bool
    let action: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        HStack {
            if let icon = item.icon {
                Image(icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.system(size: 16))
                
                if let subtitle = item.subtitle {
                    Text(subtitle)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isSelected ? Color.white : Color(.systemGray6))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isSelected || isPressed ? Color.black : Color.clear, lineWidth: isSelected || isPressed ? 2 : 0)
        )
        .contentShape(Rectangle())
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .opacity(isDisabled && !isSelected ? 0.5 : 1.0)
        .onTapGesture {
            guard !isDisabled || isSelected else { return }
            
            withAnimation(.easeInOut(duration: 0.2)) {
                isPressed = true
                action()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation {
                    isPressed = false
                }
            }
        }
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

#Preview {
    OnboardingMainView()
}
