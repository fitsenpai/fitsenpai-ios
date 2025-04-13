//
//  MealView.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/24/24.
//

import SwiftUI

struct MealView: View {
    var image: String
    var title: String
    var mealPeriod: FSMealPeriod
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            
            /// NOTE: Hiding image for now
            // Image(image)
            //     .resizable()
            //     .scaledToFit()
            //     .frame(width: 80, height: 80)
            //     .clipShape(.rect(cornerRadius: 8))
            
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .center) {
                    FSTextView(title, typography: .p_ui_medium)
                    Spacer()
                    GrayPillView(text: String(describing: mealPeriod), fontStyle: .body10)
                }
                NutrientsInfoView(calorieAmount: 350, proteinAmount: 30, carbsAmount: 40, fatAmount: 15)
            }
            .padding(.horizontal, 12)
        }
        .frame(height: 80)
        .background(Color.white.colorMultiply(.clear))
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray230, lineWidth: 1)
        }
    }
}

#Preview {
    MealView(image: "sample1", title: "Protein Pancakes", mealPeriod: .Breakfast)
}
    
