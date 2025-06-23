//
//  MealsView.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/22/24.
//

import SwiftUI

struct MealsView: View {
    
    @StateObject private var viewModel: MealsViewModel = MealsViewModel()
    @StateObject private var calendarManager = CalendarDataManager.shared
    
    let columns = [
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8)
    ]
    
    var generatingViewModel: FSInfoViewModel {
        .init(
            iconName: nil,
            title: "Generating meals...",
            mainLabel: "This won't take long. Please don't exit.",
            buttonLabel: "",
            containerHeight: .infinity,
            showButton: false,
            isLoading: true,
            buttonAction: {
                triggerHaptics()
            }
        )
    }
    
    var readyViewModel: FSInfoViewModel {
        .init(
            iconName: .iconBoxSparcle,
            title: "Your meal plan is ready!",
            mainLabel: "Tap below to generate meals for \nthe week",
            buttonLabel: "Generate meals",
            buttonAction: {
                Task {
                    await viewModel.getMealPlan()
                }
                triggerHaptics()
            }
        )
    }
    
    func errorInfoViewModel(error: Error) -> FSInfoViewModel {
        .init(
            iconName: .iconBoxWarning,
            title: "Error Generating Meals",
            mainLabel: error.localizedDescription,
            buttonLabel: "Retry",
            buttonAction: {
                Task {
                    await viewModel.getMealPlan()
                }
                triggerHaptics()
            }
        )
    }
    
    var body: some View {
        MainContainerView {
            VStack(spacing: 20) {
                switch viewModel.viewState {
                case .loading:
                    ShimmerMealsView()
                case   .fetching, .updating:
                    FSInfoView(viewModel: generatingViewModel)
                        .padding(.vertical, 12)
                case .idle:
                    if let mealDay = viewModel.mealDay {
                        VStack(spacing: 16) {
                            FSSectionHeaderView(text: "Meals") {
                                // Optional: Add action for header button if needed
                            }
                            gridView
                        }
                        ScrollView {
                            VStack(spacing: 12) {
                                MealItemView(meal: mealDay.meals.breakfast, type: .breakfast)
                                    .onTapGesture {
                                        viewModel.setSelectedMeal(meal: mealDay.meals.breakfast, type: .breakfast)
                                    }
                                
                                MealItemView(meal: mealDay.meals.lunch, type: .lunch)
                                    .onTapGesture {
                                        viewModel.setSelectedMeal(meal: mealDay.meals.lunch, type: .lunch)
                                    }
                                
                                MealItemView(meal: mealDay.meals.dinner, type: .dinner)
                                    .onTapGesture {
                                        viewModel.setSelectedMeal(meal: mealDay.meals.dinner, type: .dinner)
                                    }
                                
                                MealItemView(meal: mealDay.meals.snack, type: .snack)
                                    .onTapGesture {
                                        viewModel.setSelectedMeal(meal: mealDay.meals.snack, type: .snack)
                                    }
                                
                                MealItemView(meal: mealDay.meals.postWorkout, type: .postWorkout)
                                    .onTapGesture {
                                        viewModel.setSelectedMeal(meal: mealDay.meals.postWorkout, type: .postWorkout)
                                    }
                            }
                            .padding(.horizontal, 1)
                            .sheet(item: $viewModel.selectedMeal, content: { meal in
                                MealDetailView(meal: meal, type: viewModel.selectedMealType)
                            })
                        }
                    } else {
                        FSInfoView(viewModel: readyViewModel)
                        Spacer()
                    }
                case .error(let error):
                    FSInfoView(viewModel: errorInfoViewModel(error: error))
                        .padding(.vertical, 12)
                    Spacer()
                default:
                    Text("Unhandled view state.") // Fallback
                }
            }
            .onReceive(calendarManager.$selectedDate, perform: { date in
                viewModel.updateSelectedMealData(for: date)
            })
            .onReceive(viewModel.$mealsWeek, perform: { weeks in
                configureCalendar(with: weeks)
            })
            // This helps if the view appears after the initial data load.
            .onAppear {
                if !viewModel.mealsWeek.isEmpty {
                    viewModel.updateSelectedMealData(for: calendarManager.selectedDate)
                }
            }
        }
    }
    
    var gridView: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            if let macros = viewModel.mealDay?.totalDailyMacros {
                MacrosItemView(name: "Calories", metric: .Calories, value: macros.calories, fontColor: .calorieGreen, bgColor: .calorieGreenBG)
                
                MacrosItemView(name: "Protein", metric: .Protein, value: macros.protein, fontColor: .proteinOrange, bgColor: .proteinOrangeBG)
                
                MacrosItemView(name: "Carbs", metric: .Carbs, value: macros.carbs, fontColor: .carbBlue, bgColor: .carbBlueBG)
                
                MacrosItemView(name: "Fat", metric: .Fat, value: macros.fat, fontColor: .fatPurple, bgColor: .fatPurpleBG)
            }
        }
    }
    
    private func configureCalendar(with weeks: [WeekPlan<MealsDay>]) {
        if !weeks.isEmpty,
           let firstWeekStartDateString = weeks.min(by: { $0.week < $1.week })?.startDate,
           let overallStartDate = firstWeekStartDateString.toDate(format: "yyyy-MM-dd") {
            
            let overallEndDate = weeks.max(by: {
                $0.endDate.toDate(format: "yyyy-MM-dd") ?? Date.distantPast <
                    $1.endDate.toDate(format: "yyyy-MM-dd") ?? Date.distantPast
            })?.endDate.toDate(format: "yyyy-MM-dd") ?? Date()
            
            let currentDateToMaintain = calendarManager.selectedDate
            calendarManager.configure(startDate: overallStartDate, endDate: max(overallEndDate, Date()))
            calendarManager.selectedDate = currentDateToMaintain
            
        } else {
            calendarManager.configure(startDate: Date(), endDate: Date())
        }
        
        viewModel.updateSelectedMealData(for: calendarManager.selectedDate)
    }
}

struct MacrosItemView: View {
    var name: String
    var metric: FSMetric
    var value: Int
    var fontColor: Color
    var bgColor: Color
    var body: some View {
        HStack {
            FSTextView(name, typography: .body_medium)
            Spacer()
            IconLabelView(
                fsMetric: metric,
                value: value,
                typography: .body_bold,
                fontColor: fontColor,
                iconSize: 16
            )
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity, minHeight: 40)
        .background {
            RoundedRectangle(cornerRadius: 8)
                .fill(bgColor)
        }
    }
}

#Preview {
    MealsView()
}
