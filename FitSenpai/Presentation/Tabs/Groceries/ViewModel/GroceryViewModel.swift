//
//  GroceryViewModel.swift
//  FitSenpai
//
//  Created by Mark Daquis on 5/16/25.
//

import SwiftUI
import CoreKit
import Combine

@MainActor
class GroceryViewModel: ObservableObject {
    @Inject private var groceryPlanUseCase: GroceryPlanUseCaseProtocol
    @Inject private var updateGroceryUseCase: UpdateGroceryUseCaseProtocol
    @Inject private var groceriesDataStore: GroceriesDataStore
    
    @Published var viewState: ViewState = .loading
    @Published var selectionProgress: Double = 0.0
    @Published var totalCount: String = ""
    @Published var groceryWeeks: [GroceryWeek] = []
    @Published var selectedGroceryWeek: GroceryWeek?
    @Published var groceryWeek: GroceryWeek?
    @Published var shoppingCategoryList: [ShoppingCategory] = []
    @Published var selectedDay: WeekDayType = .monday

    private var cancellables = Set<AnyCancellable>()
    private var itemCancellables = Set<AnyCancellable>()

    init() {
        Task {
            await getGroceryPlan()
        }
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
}

extension GroceryViewModel {
    var dateRangeText: Text? {
        guard let groceryWeek, let startDate = groceryWeek.startDate.toDate(), let endDate = groceryWeek.endDate.toDate() else { return nil }
        let format = "MMM DD"
        let startDateText = startDate.toString(WithFormat: format)
        let endDateText = endDate.toString(WithFormat: format)
        let datesRange = Text("\(startDateText)-\(endDateText)").foregroundStyle(.black).bold()
        return Text("Your grocery list for \(datesRange) is ready! These items match your meal plan for the week.")
    }
}

extension GroceryViewModel {
    func getGroceryPlan() async  {
        viewState = .loading
        defer { viewState = .idle }
        do {
            self.groceryWeeks = try await groceryPlanUseCase.execute()
            self.updateSelectedGroceryData(for: Date())
        } catch {
            FSLogger.error("Failed to get grocery plan: \(error.localizedDescription)")
            viewState = .error(error)
        }
    }
    
    func updateSelectedGroceryData(for date: Date) {
        let dateFormat: String? = nil
        if let dayType = WeekDayType(rawValue: date.dayName.lowercased()) {
            self.selectedDay = dayType
        }
        
        if SuperwallManager.shared.isFirstDayTrialActive {
            self.selectedGroceryWeek = self.groceryWeeks.first
            self.groceryWeek = self.selectedGroceryWeek
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
}
