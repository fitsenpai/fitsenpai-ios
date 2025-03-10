//
//  GroceriesMainView.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/22/24.
//

import SwiftUI

struct GroceriesMainView: View {
//    @StateObject var viewModel: WorkoutsMainViewModel
//    @State private var showingDetail = false
    
    
    var listingHeader: some View {
        HStack(spacing: 12) {
            FSText(text: "Shopping list", fontStyle: .headers20, color: .fsTitle)
            Spacer()
            HStack(spacing: 15) {
                Image("ic_thumbs_up")
                    .resizable()
                    .frame(width: 16, height: 16)
                
                Image("ic_thumbs_down")
                    .resizable()
                    .frame(width: 16, height: 16)
            }
            .frame(height: 16)
        }
    }
    
    var targetGroupHorizontalList: some View {
        HStack (spacing: 12) {
            GrayPillView(text: "Total estimated cost: $250", pillHeight: 32, fontStyle: .body16)
            Spacer()
        }
    }
    
    var workoutSection: some View {
        VStack(spacing: 16) {
            VStack {
                listingHeader
                targetGroupHorizontalList
            }
            FSCompletionBarView()
            
        }
        .padding(.vertical, 16)
    }
    
    var body: some View {
        
//        ScrollView {
            VStack(alignment: .leading) {
                FSNavBarView()
                SwipeableCalendarView(shouldShowWeekView: true, selectedDate: .constant(Date()), currentWeekStartDate: .constant(Date()))
                
                workoutSection
                
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
                
                
            }
            .padding(.horizontal, 16)
            
//        }
        
        
    }
}

#Preview {
    GroceriesMainView()
}
