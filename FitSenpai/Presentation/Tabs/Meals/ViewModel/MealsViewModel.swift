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
    @Published var mealWeek: WeekPlan<MealsDay>?
    @Published var mealDay: MealsDay?
    @Published var viewState: ViewState = .loading
    @Published var selectedMeal: Meal?
    @Published var selectedMealType: MealType = .breakfast
    
    private var cancellables = Set<AnyCancellable>()

    init() {
        observeMealData()
        Task {
            await getMealPlan()
        }
    }
}

extension MealsViewModel {
    private func observeMealData() {
        mealsDataStore.$items
            .receive(on: DispatchQueue.main)
            .sink { [weak self] mealWeekEntities in
                guard let self else { return }

                self.mealsWeek = mealWeekEntities.map { $0.toDomain() }
                self.mealWeek = self.mealsWeek.first
                self.mealDay = self.mealWeek?.days.first

                if self.viewState == .loading || self.viewState == .fetching || self.viewState == .updating {
                    if mealWeekEntities.isEmpty {
                        self.viewState = .idle
                    } else {
                        self.viewState = .idle
                    }
                } else if mealWeekEntities.isEmpty && self.mealDay == nil {
                    self.viewState = .idle
                }
            }
            .store(in: &cancellables)
    }

    func getMealPlan() async  {
        switch viewState {
            case .loading, .fetching, .updating:
                return
            default:
                break
        }
        
        viewState = .loading
        do {
            _ = try await mealsPlanUseCase.execute()
            
            if viewState == .loading {
                viewState = .idle
            }
        } catch {
            FSLogger.error("Failed to get meal plan: \(error.localizedDescription)")
            viewState = .error(error)
        }
    }
    
    func setSelectedMeal(meal: Meal, type: MealType) {
        self.selectedMeal = meal
        self.selectedMealType = type
        triggerHaptics()
    }
}
