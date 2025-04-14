//
//  GroceriesMainView.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/22/24.
//

import SwiftUI

struct GroceriesMainView: View {
    
    var body: some View {
        MainContainerView {
            VStack(alignment: .leading, spacing: 20) {
                contentView
                groceryListView
            }
        }
    }
    
    var contentView: some View {
        VStack(spacing: 16) {
            FSSectionHeaderView(text: "Groceries", showGenerateButton: false) {
                
            }
            FSCompletionBarView(titleText: "10/20", progress: 0.5)
            FSCard(backgroundColor: .fsAccent) {
                Group {
                    Text("Your grocery list for ") +
                    Text("Jan 26 - Feb 1").foregroundStyle(.black).bold() +
                    Text(" is ready! These items match your meal plan for the week.")
                }
                .font(.body12)
                .frame(maxWidth: .infinity)
                .foregroundStyle(Color.fsMutedForeground)
                .lineSpacing(3)
            }
        }
    }
    
    var groceryListView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                GroceriesSectionView(selectedItems: [], foodCategory: .proteins, foodItems: [FoodItem(name: "Grilled chicken", amount: "750g"), FoodItem(name: "Salmon", amount: "750g"), FoodItem(name: "Whey protein", amount: "300g")], isShowingDetails: false)
                
                GroceriesSectionView(selectedItems: [], foodCategory: .dairyAndAlternatives, foodItems: [FoodItem(name: "Grilled chicken", amount: "750g"), FoodItem(name: "Salmon", amount: "750g"), FoodItem(name: "Whey protein", amount: "300g")], isShowingDetails: false)
                
                GroceriesSectionView(selectedItems: [], foodCategory: .vegetables, foodItems: [FoodItem(name: "Grilled chicken", amount: "750g"), FoodItem(name: "Salmon", amount: "750g"), FoodItem(name: "Whey protein", amount: "300g")], isShowingDetails: false)
                
                GroceriesSectionView(selectedItems: [], foodCategory: .oilsAndDressings, foodItems: [FoodItem(name: "Grilled chicken", amount: "750g"), FoodItem(name: "Salmon", amount: "750g"), FoodItem(name: "Whey protein", amount: "300g")], isShowingDetails: false)
                
                GroceriesSectionView(selectedItems: [], foodCategory: .fruits, foodItems: [FoodItem(name: "Grilled chicken", amount: "750g"), FoodItem(name: "Salmon", amount: "750g"), FoodItem(name: "Whey protein", amount: "300g")], isShowingDetails: false)
                
                GroceriesSectionView(selectedItems: [], foodCategory: .bakingEssentials, foodItems: [FoodItem(name: "Grilled chicken", amount: "750g"), FoodItem(name: "Salmon", amount: "750g"), FoodItem(name: "Whey protein", amount: "300g")], isShowingDetails: false)
                
                GroceriesSectionView(selectedItems: [], foodCategory: .dairyAndAlternatives, foodItems: [FoodItem(name: "Grilled chicken", amount: "750g"), FoodItem(name: "Salmon", amount: "750g"), FoodItem(name: "Whey protein", amount: "300g")], isShowingDetails: false)
            }
            .padding(.horizontal, 1)
        }
        .scrollIndicators(.hidden)
    }
}

#Preview {
    GroceriesMainView()
}
