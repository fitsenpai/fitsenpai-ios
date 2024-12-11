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
    
    
    var listingHeader: some View {
        HStack(spacing: 12) {
            FSText(text: "Protein Pancakse", fontStyle: .headers20, color: .fsTitle)
            
            GrayPillView(text: viewModel.schedule, pillHeight: 32, fontStyle: .body16)
            
            Spacer()
        }
    }
    
    
    var mealInfoHorizontalView: some View {
        HStack(spacing: 8) {
            IconLabelView(
                fsMetric: .Calories,
                value: viewModel.calories,
                fontStyle: .body16,
                fontColor: .fsSubtitleColor,
                iconSize: 16,
                spacing: 8,
                showBorder: true
            )
            .frame(width: subviewWidth)
            
            IconLabelView(
                fsMetric: .Protein,
                value: viewModel.protein,
                fontStyle: .body16,
                fontColor: .fsSubtitleColor,
                iconSize: 16,
                spacing: 8,
                showBorder: true
            )
            .frame(width: subviewWidth)
            
            IconLabelView(
                fsMetric: .Carbs,
                value: viewModel.carbs,
                fontStyle: .body16,
                fontColor: .fsSubtitleColor,
                iconSize: 16,
                spacing: 8,
                showBorder: true
            )
            .frame(width: subviewWidth)
            
            IconLabelView(
                fsMetric: .Fat,
                value: viewModel.fat,
                fontStyle: .body16,
                fontColor: .fsSubtitleColor,
                iconSize: 16,
                spacing: 8,
                showBorder: true, width: subviewWidth
            )
            .frame(width: subviewWidth)
        }
        .frame(maxWidth: .infinity, maxHeight: 60)
    }
    
    var workoutSection: some View {
        VStack(spacing: 16) {
            VStack(spacing: 8) {
                listingHeader
            }
            .padding(.bottom, 8)
            mealInfoHorizontalView
        }
        .padding(.vertical, 16)
    }
    
    var body: some View {
        ScrollView {
            VStack {
                workoutSection
                FSImageView(url: nil, placeHolder: "img_meal")
                    .frame(height: 200)
                    .padding(.bottom, 16)
                
                
                VStack (spacing: 20) {
                    GenericTextListView(title: "Ingredients", instructions: viewModel.ingredients, isNumbered: false)
                    GenericTextListView(title: "Recipe", instructions: viewModel.recipe, isNumbered: true)
                }
            }
        }
        .scrollIndicators(.hidden)
        .background {
            Color.workoutBackgroundColor
        }
        .padding(16)
        
    }
}

struct MealDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = MealDetailViewModel()
        MealDetailView(viewModel: viewModel)
    }
}
