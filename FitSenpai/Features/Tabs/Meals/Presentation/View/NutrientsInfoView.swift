//
//  NutrientsInfoView.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/24/24.
//

import SwiftUI

struct NutrientsInfoView: View {
    var calorieAmount: Int
    var proteinAmount: Int
    var carbsAmount: Int
    var fatAmount: Int
    
    var body: some View {
        HStack(spacing: 8) {
            IconLabelView(fsMetric: .Calories, value: calorieAmount, typography: .detail, fontColor: .fsMutedForeground, iconSize: 12)
            
            IconLabelView(fsMetric: .Protein, value: proteinAmount, typography: .detail, fontColor: .fsMutedForeground, iconSize: 12)
            
            IconLabelView(fsMetric: .Carbs, value: carbsAmount, typography: .detail, fontColor: .fsMutedForeground, iconSize: 12)
            
            IconLabelView(fsMetric: .Fat, value: fatAmount, typography: .detail, fontColor: .fsMutedForeground, iconSize: 12)
        }
    }
}

#Preview {
    NutrientsInfoView(calorieAmount: 350, proteinAmount: 30, carbsAmount: 40, fatAmount: 15)
}
