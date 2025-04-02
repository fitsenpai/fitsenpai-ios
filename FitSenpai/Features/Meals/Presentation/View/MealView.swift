//
//  MealView.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/24/24.
//

import SwiftUI

struct MealView: View {
    var title: String
    var mealPeriod: FSMealPeriod
    
    var horizontalInfoView: some View  {
        HStack {
            IconLabelView(fsMetric: .WorkoutSet, value: 4, fontStyle: .body12, fontColor: .fsSubtitleColor, iconSize: 12)
            
            IconLabelView(fsMetric: .WorkoutRep, value: 12, fontStyle: .body12, fontColor: .fsSubtitleColor, iconSize: 12)
            
            IconLabelView(fsMetric: .WorkoutWeight, value: 10, fontStyle: .body12, fontColor: .fsSubtitleColor, iconSize: 12)
        }
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray230, lineWidth: 1)
            HStack(alignment: .center) {
                VStack(spacing: 12) {
                    
                    VStack(alignment: .leading, spacing: 8) {
                        FSText(text: title, fontStyle: .medium16, color: .fsTitle)
                        
                        HStack {
                            GrayPillView(text: String(describing: mealPeriod), pillHeight: 28, fontStyle: .body12)
                            NutrientsInfoView(calorieAmount: 350, proteinAmount: 30, carbsAmount: 40, fatAmount: 15)
                        }
                        
                    }
                }
                Spacer()
                Image("ic_arrow_right")
                    .resizable()
                    .frame(width: 20, height: 20)
                
            }
            .padding(12)
        }
    }
}

#Preview {
    MealView(title: "Protein Pancakes", mealPeriod: .Breakfast)
}
