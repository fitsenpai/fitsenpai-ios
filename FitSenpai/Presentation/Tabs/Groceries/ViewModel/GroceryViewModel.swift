//
//  File.swift
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
    @Published var groceryWeek: GroceryWeek?
    @Published var shoppingCategoryList: [ShoppingCategory] = [] {
        didSet {
            if !isUpdatingFromStore {
                observeItemChanges()
                recalculateProgress(fromUserInteraction: true)
            } else {
                observeItemChanges()
                recalculateProgress(fromUserInteraction: false)
            }
        }
    }

    private var cancellables = Set<AnyCancellable>()
    private var itemCancellables = Set<AnyCancellable>()
    
    private var isUpdatingFromStore: Bool = false

    init() {
        observeGroceryData()
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
    private func observeGroceryData() {
        groceriesDataStore.$items
            .receive(on: DispatchQueue.main)
            .sink { [weak self] groceryWeekEntities in
                guard let self else { return }
                self.isUpdatingFromStore = true

                self.groceryWeeks = groceryWeekEntities.map { $0.toDomain() }
                self.groceryWeek = self.groceryWeeks.first
                
                let unsortedShoppingCategories = self.groceryWeek?.shopping ?? []
                self.shoppingCategoryList = unsortedShoppingCategories.sorted { $0.category.lowercased() < $1.category.lowercased() }
                
                if groceryWeekEntities.isEmpty {
                    if self.viewState != .error(NSError()) {
                        self.viewState = .idle
                    }
                } else {
                     if self.viewState != .error(NSError()) {
                        self.viewState = .idle
                    }
                }
                
                self.isUpdatingFromStore = false
            }
            .store(in: &cancellables)
    }

    func getGroceryPlan() async  {
        switch viewState {
            case .loading, .fetching, .updating:
                return
            default:
                break
        }

        viewState = .loading
        do {
            _ = try await groceryPlanUseCase.execute()
            
            if viewState == .loading {
                viewState = .idle
            }
        } catch {
            FSLogger.error("Failed to get grocery plan: \(error.localizedDescription)")
            viewState = .error(error)
        }
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
        } else {
        }
    }
}
