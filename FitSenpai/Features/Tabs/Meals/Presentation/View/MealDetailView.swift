//
//  MealDetailView.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 12/11/24.
//

import SwiftUI

struct MealDetailView: View {
    
    @ObservedObject var viewModel: MealDetailViewModel
    
    private var subviewWidth: CGFloat {
        let w = UIScreen.main.bounds.width - 32
        return (w - 1 * 3 - 8 * 3) / 4 // Calculate the width for each subview
    }
    
    var header: some View {
        VStack(alignment: .leading, spacing: 12) {
            SheetIndicator()
            HStack {
                FSText(text: "Protein Pancakse", fontStyle: .heading20, color: .fsTitle)
                Spacer()
                Image(.iconBookmark)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)
            }
            GrayPillView(text: viewModel.schedule, fontStyle: .body14, cornerRadius: 24)
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                header
                mealInfoHorizontalView
                
                Image("img_meal")
                    .resizable()
                    .frame(height: 200)
                
                VStack (spacing: 20) {
                    GenericTextListView(title: "Ingredients", instructions: viewModel.ingredients, isNumbered: false)
                    
                    GenericTextListView(title: "Recipe", instructions: viewModel.recipe, isNumbered: true)
                }
            }
        }
        .scrollIndicators(.hidden)
        .padding(24)
        .background {
            Color.workoutBackgroundColor
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
