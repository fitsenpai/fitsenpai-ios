//
//  MealDetailView.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 12/11/24.
//

import SwiftUI

struct MealDetailView: View {
    @EnvironmentObject private var superwall: SuperwallManager
    @ObservedObject var viewModel: MealDetailViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 12) {
            headerSection
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    GrayPillView(text: viewModel.schedule, fontStyle: .body14, cornerRadius: 24)
                    mealInfoHorizontalView
                    
                    /// NOTE: Hiding image for now
                    //  Image("img_meal")
                    //    .resizable()
                    //    .frame(height: 200)
                    
                    GenericTextListView(title: "Ingredients", instructions: viewModel.ingredients, isNumbered: false)
                    
                    GenericTextListView(title: "Recipe", instructions: viewModel.recipe, isNumbered: true)
                }
                .padding(.horizontal, 1)
            }
            .scrollIndicators(.hidden)
            
            if superwall.isFirstDayTrialActive {
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
            FSTextView("Protein Pancakse", typography: .h4)
            Spacer()
            Image(.iconBookmark)
                .resizable()
                .scaledToFit()
                .frame(width: 25, height: 25)
                .onTapGesture {
                    if superwall.isFirstDayTrialActive {
                        superwall.presentPaywall(for: .proContent)
                    }
                    triggerHaptics()
                }
        }
    }
    
    var mealInfoHorizontalView: some View {
        HStack(spacing: 2) {
            MetricsPillView(image: "icon_fire_green", value: 200, label: "kcal")
            MetricsPillView(image: "icon_bone_orange", value: 30, label: "g")
            MetricsPillView(image: "icon_bread_blue", value: 400, label: "g")
            MetricsPillView(image: "icon_avocado_purple", value: 20, label: "g")
        }
        .frame(maxWidth: .infinity)
    }
}

struct MealDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = MealDetailViewModel()
        MealDetailView(viewModel: viewModel)
    }
}
