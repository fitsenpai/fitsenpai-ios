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
        HStack(spacing: 12) {
            IconLabelView(fsMetric: .Calories, value: calorieAmount, fontStyle: .body12, fontColor: .fsSubtitleColor, iconSize: 10)
            
            IconLabelView(fsMetric: .Protein, value: proteinAmount, fontStyle: .body12, fontColor: .fsSubtitleColor, iconSize: 10)
            
            IconLabelView(fsMetric: .Carbs, value: carbsAmount, fontStyle: .body12, fontColor: .fsSubtitleColor, iconSize: 10)
            
            IconLabelView(fsMetric: .Fat, value: fatAmount, fontStyle: .body12, fontColor: .fsSubtitleColor, iconSize: 10)
        }
    }
}

#Preview {
    NutrientsInfoView(calorieAmount: 350, proteinAmount: 30, carbsAmount: 40, fatAmount: 15)
}
