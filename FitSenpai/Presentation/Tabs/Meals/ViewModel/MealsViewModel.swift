//
//  MealsViewModel.swift
//  FitSenpai
//
//  Created by Mark Daquis on 5/9/25.
//

import Foundation
import CoreKit
import Combine

@MainActor
class MealsViewModel: ObservableObject {
    @Inject private var mealsPlanUseCase: MealsPlanUseCaseProtocol
    @Inject private var mealsDataStore: MealsDataStore
    
    @Published var mealsWeek: [WeekPlan<MealsDay>] = []
    @Published var selectedMealWeek: WeekPlan<MealsDay>?
    @Published var selectedMealDay: MealsDay?
    @Published var mealDay: MealsDay?
    @Published var viewState: ViewState = .loading
    @Published var selectedMeal: Meal?
    @Published var selectedMealType: MealType = .breakfast
    @Published var selectedDay: WeekDayType = .monday
    
    private var cancellables = Set<AnyCancellable>()

    init() {
        Task {
            await getMealPlan()
        }
    }
}

extension MealsViewModel {
    func getMealPlan() async  {
        
        viewState = .loading
        defer { viewState = .idle }
        do {
            self.mealsWeek = try await mealsPlanUseCase.execute()
            self.updateSelectedMealData(for: Date())
        } catch {
            FSLogger.error("Failed to get meal plan: \(error.localizedDescription)")
            viewState = .error(error)
        }
    }
    
    func updateSelectedMealData(for date: Date) {
        let dateFormat: String? = nil
        if let dayType = WeekDayType(rawValue: date.dayName.lowercased()) {
            self.selectedDay = dayType
        }
        
        if SuperwallManager.shared.isFirstDayTrialActive {
            self.selectedMealWeek = self.mealsWeek.first
            self.selectedMealDay = self.selectedMealWeek?.days.first
            self.mealDay = self.selectedMealDay
            return
        }
        
        let targetWeek = self.mealsWeek.first { weekPlan in
            guard let weekStartDate = weekPlan.startDate.toDate(format: dateFormat)?.startOfDay,
                  let weekEndDate = weekPlan.endDate.toDate(format: dateFormat)?.startOfDay,
                  let nextDayAfterWeekEndDate = Calendar.current.date(byAdding: .day, value: 1, to: weekEndDate) else {
                return false
            }
            return date.startOfDay >= weekStartDate && date.startOfDay < nextDayAfterWeekEndDate
        }
        
        self.selectedMealWeek = targetWeek
        
        if let week = targetWeek, let dayType = WeekDayType(rawValue: date.dayName.lowercased()) {
            self.selectedMealDay = week.days.first { $0.day.lowercased() == dayType.rawValue }
            self.mealDay = self.selectedMealDay
        } else {
            self.selectedMealDay = nil
            self.mealDay = nil
        }
    }
    
    func setSelectedMeal(meal: Meal, type: MealType) {
        self.selectedMeal = meal
        self.selectedMealType = type
        triggerHaptics()
    }
}
