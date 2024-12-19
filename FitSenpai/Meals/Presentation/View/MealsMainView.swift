//
//  MealsMainView.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/22/24.
//

import SwiftUI

struct MealsMainView: View {
    
    @State var showingDetail = false
    
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
    
    var gridView: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(items, id: \.0) { item in
                HStack {
                    FSText(text: item.0, fontStyle: .medium14)
                    IconLabelView(
                        fsMetric: item.4,
                        value: item.1,
                        fontStyle: .body14,
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
    
    var listingHeader: some View {
        HStack(spacing: 12) {
            Image("ic_utensils")
                .resizable()
                .frame(width: 32, height: 32)
            FSText(text: "Today's meals", fontStyle: .headers20, color: .fsTitle)
            Spacer()
        }
    }
    
    
    var workoutSection2: some View {
        VStack(spacing: 20) {
            VStack(spacing: 16) {
                listingHeader
                gridView
            }
            
            ScrollView {
                VStack(spacing: 12) {
                    MealView(title: "Protein Pancakes", mealPeriod: .Breakfast)
                        .frame(height: 88)

                    MealView(title: "Chicken Salad", mealPeriod: .Lunch)
                        .frame(height: 88)
                    
                    MealView(title: "Salmon and Asparagus", mealPeriod: .Dinner)
                        .frame(height: 88)
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
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            FSText(text: "Meal planner", fontStyle: .headers24, color: .fsTitle)
            SwipeableCalendarView(selectedDate: .constant(Date()), currentWeekStartDate: .constant(Date()))
            
            workoutSection2
            
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    MealsMainView()
}
