//
//  GroceriesMainView.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/22/24.
//

import SwiftUI

struct GroceriesMainView: View {
    
    var body: some View {
        VStack(alignment: .leading) {
            FSNavBarView()
            SwipeableCalendarView(shouldShowWeekView: true, selectedDate: .constant(Date()), currentWeekStartDate: .constant(Date()))
            
            VStack(spacing: 16) {
                FSSectionHeaderView(text: "Groceries", showGenerateButton: false)
                FSCompletionBarView(titleText: "10/20", progress: 0.5)
                FSCard(backgroundColor: .fsAccent) {
                    Group {
                        Text("Your grocery list for ") +
                        Text("Jan 26 - Feb 1").foregroundStyle(.black).bold() +
                        Text(" is ready! These items match your meal plan for the week.")
                    }
                    .font(.body12)
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(Color.fsSubtitleColor)
                    .lineSpacing(3)
                }
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 24)
            
            groceryListView
        }
    }
    
    var groceryListView: some View {
        ScrollView {
            GroceriesSectionView(selectedItems: [], foodCategory: .proteins, foodItems: [FoodItem(name: "Grilled chicken", amount: "750g"), FoodItem(name: "Salmon", amount: "750g"), FoodItem(name: "Whey protein", amount: "300g")], isShowingDetails: false)
            
            GroceriesSectionView(selectedItems: [], foodCategory: .dairyAndAlternatives, foodItems: [FoodItem(name: "Grilled chicken", amount: "750g"), FoodItem(name: "Salmon", amount: "750g"), FoodItem(name: "Whey protein", amount: "300g")], isShowingDetails: false)
            
            GroceriesSectionView(selectedItems: [], foodCategory: .vegetables, foodItems: [FoodItem(name: "Grilled chicken", amount: "750g"), FoodItem(name: "Salmon", amount: "750g"), FoodItem(name: "Whey protein", amount: "300g")], isShowingDetails: false)
            
            GroceriesSectionView(selectedItems: [], foodCategory: .oilsAndDressings, foodItems: [FoodItem(name: "Grilled chicken", amount: "750g"), FoodItem(name: "Salmon", amount: "750g"), FoodItem(name: "Whey protein", amount: "300g")], isShowingDetails: false)
            
            GroceriesSectionView(selectedItems: [], foodCategory: .fruits, foodItems: [FoodItem(name: "Grilled chicken", amount: "750g"), FoodItem(name: "Salmon", amount: "750g"), FoodItem(name: "Whey protein", amount: "300g")], isShowingDetails: false)
            
            GroceriesSectionView(selectedItems: [], foodCategory: .bakingEssentials, foodItems: [FoodItem(name: "Grilled chicken", amount: "750g"), FoodItem(name: "Salmon", amount: "750g"), FoodItem(name: "Whey protein", amount: "300g")], isShowingDetails: false)
            
            GroceriesSectionView(selectedItems: [], foodCategory: .dairyAndAlternatives, foodItems: [FoodItem(name: "Grilled chicken", amount: "750g"), FoodItem(name: "Salmon", amount: "750g"), FoodItem(name: "Whey protein", amount: "300g")], isShowingDetails: false)
        }
        .scrollIndicators(.hidden)
        .padding(.horizontal, 24)
    }
}

#Preview {
    GroceriesMainView()
}
