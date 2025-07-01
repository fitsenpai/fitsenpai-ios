//
//  MealDetailView.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 12/11/24.
//

import SwiftUI

struct MealDetailView: View {
    @EnvironmentObject private var superwall: SuperwallManager
    @Environment(\.dismiss) private var dismiss
    
    var meal: Meal
    var type: MealType
    
    var body: some View {
        VStack(spacing: 12) {
            headerSection
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    GrayPillView(text: type.name, fontStyle: .body14, cornerRadius: 24)
                    mealInfoHorizontalView
                    
                    /// NOTE: Hiding image for now
                    //  Image("img_meal")
                    //    .resizable()
                    //    .frame(height: 200)
                    
                    GenericTextListView(title: "Ingredients", instructions: meal.ingredients, isNumbered: false)
                    
                    GenericTextListView(title: "Recipe", instructions: meal.recipe, isNumbered: true)
                }
                .padding(.horizontal, 1)
            }
            .scrollIndicators(.hidden)
            
            if superwall.isTrialActive {
                FSButton(title: "Unlock full week", fontStyle: .bodyBold16, cornerRadius: 32, tapAction: {
                    triggerHaptics()
                    superwall.presentPaywall(for: .proContent)
                })
            }
        }
        .padding(24)
        .background {
            Color.workoutBackgroundColor
        }
        .overlay(alignment: .top) {
            SheetIndicator()
                .padding(12)
        }
    }
    
    var headerSection: some View {
        HStack {
            FSTextView(meal.name, typography: .h4)
            Spacer()
            Image(.iconBookmark)
                .resizable()
                .scaledToFit()
                .frame(width: 25, height: 25)
                .onTapGesture {
                    if superwall.isTrialActive {
                        superwall.presentPaywall(for: .proContent)
                    }
                    triggerHaptics()
                }
        }
    }
    
    var mealInfoHorizontalView: some View {
        HStack(spacing: 4) {
            MetricsPillView(image: "icon_fire_green", value: meal.macros.calories, label: "kcal")
            MetricsPillView(image: "icon_bone_orange", value: meal.macros.protein, label: "g")
            MetricsPillView(image: "icon_bread_blue", value: meal.macros.carbs, label: "g")
            MetricsPillView(image: "icon_avocado_purple", value: meal.macros.fat, label: "g")
        }
        .frame(maxWidth: .infinity)
    }
}

