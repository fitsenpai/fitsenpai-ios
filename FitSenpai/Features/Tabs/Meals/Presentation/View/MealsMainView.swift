//
//  MealsMainView.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/22/24.
//

import SwiftUI

struct MealsMainView: View {
    
    @State var showingDetail = false
    
    @State private var selectedDate: Date = Date()
    
    let items = [
        ("Calories", 1558, Color.calorieGreenBG, Color.calorieGreen, FSMetric.Calories),
        ("Protein", 118, Color.proteinOrangeBG, Color.proteinOrange, FSMetric.Protein),
        ("Carbs", 126, Color.carbBlueBG, Color.carbBlue, FSMetric.Carbs),
        ("Fat", 64, Color.fatPurpleBG, Color.fatPurple, FSMetric.Fat)
    ]
    
    let columns = [
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8)
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            FSNavBarView()
            SwipeableCalendarView(selectedDate: $selectedDate, currentWeekStartDate: .constant(Date()))
            VStack(spacing: 20) {
                VStack(spacing: 16) {
                    FSSectionHeaderView(text: "Meals")
                    gridView
                }
                
                ScrollView {
                    VStack(spacing: 12) {
                        MealView(image: "sample1", title: "Protein Pancakes", mealPeriod: .Breakfast)

                        MealView(image: "sample2", title: "Chicken Salad", mealPeriod: .Lunch)
                        
                        MealView(image: "sample3", title: "Salmon and Asparagus", mealPeriod: .Dinner)
                        
                        MealView(image: "sample4", title: "Salmon and Asparagus", mealPeriod: .Lunch)
                    }
                    .onTapGesture {
                        showingDetail.toggle()
                    }
                    .sheet(isPresented: $showingDetail, content: {
                        MealDetailView(viewModel: MealDetailViewModel())
                    })
                    .padding(.horizontal, 1)
                }
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 24)
        }
    }
    
    var gridView: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(items, id: \.0) { item in
                HStack {
                    FSText(text: item.0, fontStyle: .medium14)
                    Spacer()
                    IconLabelView(
                        fsMetric: item.4,
                        value: item.1,
                        fontStyle: .bodyBold14,
                        fontColor: item.3,
                        iconSize: 16
                    )
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity, minHeight: 40)
                .background {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(item.2)
                }
            }
        }
    }
}

#Preview {
    MealsMainView()
}
