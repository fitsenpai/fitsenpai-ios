//
//  MealItemView.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/24/24.
//

import SwiftUI

struct MealItemView: View {
    var meal: Meal
    var type: MealType
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            
            /// NOTE: Hiding image for now
            // Image(meal.imageUrl)
            //     .resizable()
            //     .scaledToFit()
            //     .frame(width: 80, height: 80)
            //     .clipShape(.rect(cornerRadius: 8))
            
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .center) {
                    FSTextView(meal.name, typography: .p_ui_medium, lineLimit: 1)
                    Spacer()
                    GrayPillView(text:  type.name, fontStyle: .body10)
                }
                NutrientsInfoView(calorieAmount: meal.macros.calories, proteinAmount: meal.macros.protein, carbsAmount: meal.macros.carbs, fatAmount: meal.macros.fat)
            }
            .padding(16)
        }
        .background(Color.white.colorMultiply(.clear))
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray230, lineWidth: 1)
        }
    }
}
