//
//  MealsView.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/22/24.
//

import SwiftUI

struct MealsView: View {
    
    @StateObject private var viewModel: MealsViewModel = MealsViewModel()
    
    let columns = [
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8)
    ]
    
    var generatingViewModel: FSInfoViewModel {
        .init(
            iconName: nil,
            title: "Generating meals...",
            mainLabel: "This won’t take long. Please don’t exit.",
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
                case .loading, .fetching, .updating:
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
                default:
                    Text("Unhandled view state.") // Fallback
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
