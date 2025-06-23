//
//  MealsView.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/22/24.
//

import SwiftUI

struct MealsView: View {
    
    @ObservedObject var viewModel: MealsViewModel
    @StateObject private var calendarManager = CalendarDataManager.shared
    @State private var pollingTimer: Timer?
    @State private var mealPollingTimer: Timer?
    
    let columns = [
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8)
    ]
    
    private var shouldShowGenerateButton: Bool {
        let selectedDate = calendarManager.selectedDate
        let currentWeekStart = Calendar.current.dateInterval(of: .weekOfYear, for: Date())?.start ?? Date()
        let selectedWeekStart = Calendar.current.dateInterval(of: .weekOfYear, for: selectedDate)?.start ?? selectedDate
        
        // Show button only if selected week is current week or future week
        return selectedWeekStart >= currentWeekStart
    }
    
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
                    await viewModel.generateMealPlan(date: calendarManager.selectedDate)
                }
                triggerHaptics()
            }
        )
    }
    
    var errorInfoViewModel: FSInfoViewModel {
        .init(
            iconName: .iconBoxWarning,
            title: "Error Generating Meals",
            mainLabel: "An error occurred while generating your meal plan.",
            buttonLabel: "Retry",
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
                case .loading, .uploading:
                    ShimmerMealsView()
                case .fetching:
                    FSInfoView(viewModel: generatingViewModel)
                        .padding(.vertical, 12)
                case .idle:
                    if viewModel.isMealGenerationPending {
                        FSInfoView(viewModel: generatingViewModel)
                            .padding(.vertical, 12)
                    } else if let mealDay = viewModel.mealDay {
                        VStack(spacing: 16) {
                            FSSectionHeaderView(text: "Meals", showGenerateButton: shouldShowGenerateButton) {
                                triggerHaptics()
                                Task {
                                    await viewModel.regenerateMealPlan(date: calendarManager.selectedDate)
                                }
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
                print("🔄 MealsView: Calendar date changed, calling updateSelectedData")
                viewModel.updateSelectedData(for: date)
            })
            .onAppear {
                print("🔄 MealsView: onAppear called")
                if !viewModel.mealsWeek.isEmpty {
                    viewModel.updateSelectedData(for: calendarManager.selectedDate)
                }
            }
            .onChange(of: viewModel.shouldPoll) { oldValue, newValue in
                print("🔄 MealsView: shouldPoll changed from \(oldValue) to \(newValue)")
                if newValue {
                    print("🔄 MealsView: Should start polling via shouldPoll change")
                    startMealPollingIfNeeded()
                } else {
                    print("🔄 MealsView: Should stop polling via shouldPoll change")
                    stopMealPolling()
                }
            }
            .onChange(of: viewModel.viewState) { oldState, newState in
                print("🔄 MealsView: viewState changed from \(oldState) to \(newState)")
                // Start polling when generation completes and polling is needed
                if case .idle = newState, viewModel.shouldPoll {
                    print("🔄 MealsView: Generation complete and polling needed - starting timer via viewState")
                    startMealPollingIfNeeded()
                }
            }
            .onChange(of: viewModel.shouldPollMeals) { _, shouldPoll in
                if shouldPoll {
                    startMealPollingIfNeeded()
                } else {
                    stopMealPolling()
                }
            }
            .onChange(of: viewModel.viewState) { _, newState in
                // Start polling when generation completes and polling is needed
                if case .idle = newState, viewModel.shouldPollMeals {
                    startMealPollingIfNeeded()
                }
            }
        }
    }
    
    private func startMealPollingIfNeeded() {
        guard viewModel.shouldPollMeals else { return }
        
        // Don't restart if already polling
        guard pollingTimer == nil else { return }
        
        pollingTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
            Task {
                await viewModel.checkMealGenerationStatus()
            }
        }
    }
    
    private func stopMealPolling() {
        pollingTimer?.invalidate()
        pollingTimer = nil
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
    MealsView(viewModel: MealsViewModel())
}
