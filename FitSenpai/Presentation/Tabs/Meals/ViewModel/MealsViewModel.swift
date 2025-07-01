//
//  MealsViewModel.swift
//  FitSenpai
//
//  Created by Mark Daquis on 5/9/25.
//

import Foundation
import CoreKit
import Combine
import SwiftUI

@MainActor
class MealsViewModel: ObservableObject, HandlesErrors {
    
    // MARK: - Meals Properties
    @Published var mealsWeek: [WeekPlan<MealsDay>] = []
    @Published var selectedMealWeek: WeekPlan<MealsDay>?
    @Published var selectedMealDay: MealsDay?
    @Published var mealDay: MealsDay?
    @Published var selectedMeal: Meal?
    @Published var selectedMealType: MealType = .breakfast
    
    // MARK: - Grocery Properties
    @Published var groceryWeeks: [GroceryWeek] = []
    @Published var selectedGroceryWeek: GroceryWeek?
    @Published var groceryWeek: GroceryWeek?
    @Published var shoppingCategoryList: [ShoppingCategory] = []
    @Published var selectionProgress: Double = 0.0
    @Published var totalCount: String = ""
    
    // MARK: - Shared Properties
    @Published var viewState: ViewState = .loading
    @Published var selectedDay: WeekDayType = .monday
    @Published var showGenerateSheet: Bool = false

    // MARK: - Polling Properties
    @Published var isMealGenerationPending = false
    @Published var isGroceryGenerationPending = false
    
    private var cancellables = Set<AnyCancellable>()
    private var itemCancellables = Set<AnyCancellable>()
    
    // MARK: - Polling Control
    private var isCheckingStatus = false

    // MARK: - Meal Dependencies
    @Inject private var mealsDataStore: MealsDataStore
    @Inject private var mealsPlanUseCase: MealsPlanUseCaseProtocol
    @Inject private var generateMealPlanUseCase: GenerateMealsPlanUseCaseProtocol
    @Inject private var regenerateMealPlanUseCase: RegenerateMealsPlanUseCaseProtocol
    
    // MARK: - Grocery Dependencies
    @Inject private var groceryPlanUseCase: GroceryPlanUseCaseProtocol
    @Inject private var updateGroceryUseCase: UpdateGroceryUseCaseProtocol
    @Inject private var groceriesDataStore: GroceriesDataStore
    
    init() {
        Task {
            await loadInitialData()
        }
    }
    
    private func loadInitialData() async {
        await getMealPlan()
        await getGroceryPlan()
    }
    
    private func observeItemChanges() {
        itemCancellables.removeAll()
        for category in shoppingCategoryList {
            for item in category.items {
                item.objectWillChange
                    .sink { [weak self] _ in
                        self?.recalculateProgress(fromUserInteraction: true)
                    }
                    .store(in: &itemCancellables)
            }
        }
    }
    
    // MARK: - Meal Methods
    func getMealPlan() async {
        viewState = .loading
        do {
            self.mealsWeek = try await mealsPlanUseCase.execute()
            self.updateSelectedMealData(for: Date())
            self.viewState = .idle
        } catch {
            handleError(error, message: "Failed to get meal plan")
        }
    }
    
    func checkMealGenerationStatus() async {
        guard !isCheckingStatus else { return }
        isCheckingStatus = true
        defer { isCheckingStatus = false }
        
        do {
            let updatedMealsWeek = try await mealsPlanUseCase.execute()
            self.mealsWeek = updatedMealsWeek
            
            let currentDate = CalendarDataManager.shared.selectedDate
            self.updateSelectedMealData(for: currentDate)
            
        } catch {
            FSLogger.error("Failed to check meal generation status: \(error.localizedDescription)")
        }
    }
    
    func checkGroceryGenerationStatus() async {
        guard !isCheckingStatus else { return }
        isCheckingStatus = true
        defer { isCheckingStatus = false }
        
        do {
            let updatedGroceryWeeks = try await groceryPlanUseCase.execute()
            self.groceryWeeks = updatedGroceryWeeks
            
            let currentDate = CalendarDataManager.shared.selectedDate
            self.updateSelectedGroceryData(for: currentDate)
            
        } catch {
            FSLogger.error("Failed to check grocery generation status: \(error.localizedDescription)")
        }
    }
    
    func generateMealPlan(date: Date) async {
        viewState = .fetching
        do {
            let selectedDate = date.toString(WithFormat: "yyyy-MM-dd")
            try await generateMealPlanUseCase.execute(date: selectedDate)
            
            async let mealsResult = mealsPlanUseCase.execute()
            async let groceriesResult = groceryPlanUseCase.execute()
            
            self.mealsWeek = try await mealsResult
            self.groceryWeeks = try await groceriesResult
            
            self.updateSelectedMealData(for: date)
            self.updateSelectedGroceryData(for: date)
            
            self.viewState = .idle
            
        } catch {
            handleError(error, message: "Failed to generate meal plan")
        }
    }
    
    func regenerateMealPlan(date: Date, instruction: String) async {
        viewState = .fetching
        do {
            let selectedDate = date.toString(WithFormat: "yyyy-MM-dd")
            try await regenerateMealPlanUseCase.execute(date: selectedDate, instruction: instruction)
            
            async let mealsResult = mealsPlanUseCase.execute()
            async let groceriesResult = groceryPlanUseCase.execute()
            
            self.mealsWeek = try await mealsResult
            self.groceryWeeks = try await groceriesResult
            
            self.updateSelectedMealData(for: date)
            self.updateSelectedGroceryData(for: date)
            
            self.viewState = .idle
            
        } catch {
            handleError(error, message: "Failed to regenerate meal plan")
        }
    }
    
    func setSelectedMeal(meal: Meal, type: MealType) {
        self.selectedMeal = meal
        self.selectedMealType = type
        triggerHaptics()
    }
    
    // MARK: - Grocery Methods
    var dateRangeText: Text? {
        guard let groceryWeek, let startDate = groceryWeek.startDate.toDate(), let endDate = groceryWeek.endDate.toDate() else { return nil }
        let format = "MMM DD"
        let startDateText = startDate.toString(WithFormat: format)
        let endDateText = endDate.toString(WithFormat: format)
        let datesRange = Text("\(startDateText)-\(endDateText)").foregroundStyle(.black).bold()
        return Text("Your grocery list for \(datesRange) is ready! These items match your meal plan for the week.")
    }
    
    func getGroceryPlan() async {
        do {
            self.groceryWeeks = try await groceryPlanUseCase.execute()
            self.updateSelectedGroceryData(for: Date())
            self.viewState = .idle
        } catch {
            FSLogger.error("Failed to get grocery plan: \(error.localizedDescription)")
            if case .error(_) = viewState {
                // Already in error state, don't override
            } else {
                viewState = .error(error)
            }
        }
    }
    
    func updateSelectedGroceryData(for date: Date) {
        let dateFormat: String? = nil
        if let dayType = WeekDayType(rawValue: date.dayName.lowercased()) {
            self.selectedDay = dayType
        }
        
        if SuperwallManager.shared.isTrialActive {
            self.selectedGroceryWeek = self.groceryWeeks.first
            self.groceryWeek = self.selectedGroceryWeek
            self.isGroceryGenerationPending = self.selectedGroceryWeek?.pendingGeneration ?? false
            self.updateShoppingCategories()
            return
        }
        
        let targetWeek = self.groceryWeeks.first { weekPlan in
            guard let weekStartDate = weekPlan.startDate.toDate(format: dateFormat)?.startOfDay,
                  let weekEndDate = weekPlan.endDate.toDate(format: dateFormat)?.startOfDay,
                  let nextDayAfterWeekEndDate = Calendar.current.date(byAdding: .day, value: 1, to: weekEndDate) else {
                return false
            }
            return date.startOfDay >= weekStartDate && date.startOfDay < nextDayAfterWeekEndDate
        }
        
        self.selectedGroceryWeek = targetWeek
        self.groceryWeek = self.selectedGroceryWeek
        self.isGroceryGenerationPending = self.selectedGroceryWeek?.pendingGeneration ?? false
        self.updateShoppingCategories()
    }
    
    private func updateShoppingCategories() {
        let unsortedShoppingCategories = self.groceryWeek?.shopping ?? []
        self.shoppingCategoryList = unsortedShoppingCategories.sorted { $0.category.lowercased() < $1.category.lowercased() }
        observeItemChanges()
        recalculateProgress(fromUserInteraction: false)
    }
    
    func recalculateProgress(fromUserInteraction: Bool = false) {
        let allItems = shoppingCategoryList.flatMap { $0.items }
        let selectedItems = allItems.filter { $0.isSelected }
        
        withAnimation {
            if allItems.isEmpty {
                selectionProgress = 0.0
            } else {
                selectionProgress = Double(selectedItems.count) / Double(allItems.count)
            }
            totalCount = "\(selectedItems.count)/\(allItems.count)"
        }
        
        if fromUserInteraction, let groceryWeek = self.groceryWeek {
            Task { @MainActor in
                try? await updateGroceryUseCase.execute(groceryWeek.toEntity())
            }
        }
    }
    
    // MARK: - Combined Update Method
    func updateSelectedData(for date: Date) {
        updateSelectedMealData(for: date)
        updateSelectedGroceryData(for: date)
    }
    
    func updateSelectedMealData(for date: Date) {
        let dateFormat: String? = nil
        if let dayType = WeekDayType(rawValue: date.dayName.lowercased()) {
            self.selectedDay = dayType
        }
        
        if SuperwallManager.shared.isTrialActive {
            self.selectedMealWeek = self.mealsWeek.first
            self.selectedMealDay = self.selectedMealWeek?.days.first
            self.mealDay = self.selectedMealDay
            self.isMealGenerationPending = self.selectedMealDay?.pendingGeneration ?? false
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
            self.isMealGenerationPending = self.selectedMealDay?.pendingGeneration ?? false
        } else {
            self.selectedMealDay = nil
            self.mealDay = nil
            self.isMealGenerationPending = false
        }
    }
    
    // MARK: - Public Polling Control
    var shouldPollMeals: Bool {
        return isMealGenerationPending
    }
    
    var shouldPollGroceries: Bool {
        return isGroceryGenerationPending
    }
    
    var shouldPoll: Bool {
        return isMealGenerationPending || isGroceryGenerationPending
    }
}
