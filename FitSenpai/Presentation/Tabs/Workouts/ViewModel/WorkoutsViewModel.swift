//
//  WorkoutsMainViewModel.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/28/24.
//

import Foundation
import Combine
import CoreKit
import SwiftUI

@MainActor
class WorkoutsViewModel: ObservableObject {
    @Published var activeSheet: WorkoutSheet?
    @Published var viewState: ViewState = .loading
    @Published var workoutWeeks: [WeekPlan<WorkoutDay>] = []
    @Published var workoutWeek: WeekPlan<WorkoutDay>?
    @Published var workoutDays: [WorkoutDay] = []
    @Published var workoutDay: WorkoutDay?
    @Published var selectedRoutine: WorkoutRoutine?
    @Published var showingDetail = false
    @Published var showRateApp = false

    @Inject private var workoutPlanUseCase: WorkoutPlanUseCaseProtocol
    @Inject private var updateRoutineUseCase: UpdateRoutineUseCaseProtocol
    @Inject private var workoutDataStore: WorkoutDataStore
    
    private var cancellables = Set<AnyCancellable>()
    
    var animatedDailyProgress: Double  = 0
    var dailyProgress: Double {
        guard let routines = workoutDay?.routines else { return 0 }
        
        let completedCount = routines.filter({ $0.isCompleted }).count
        let progress = Double(completedCount) / Double(routines.count)
        withAnimation {
            self.animatedDailyProgress = progress
        }
        return progress
    }

    init() {
        observeWorkoutData()
        Task {
            await getWorkoutPlan()
        }
    }
    
}

// MARK: - Workout Data Handling
extension WorkoutsViewModel {
    private func observeWorkoutData() {
        workoutDataStore.$items
            .receive(on: DispatchQueue.main)
            .sink { [weak self] workoutWeekEntities in
                guard let self else { return }
                
                self.workoutWeeks = workoutWeekEntities.map { $0.toDomain() }
                self.workoutWeek = self.workoutWeeks.first
                self.workoutDays = self.workoutWeek?.days ?? []
                
                if var firstDay = self.workoutDays.first {
                    firstDay.routines = firstDay.routines.sorted(by: { $0.sortIndex < $1.sortIndex })
                    self.workoutDay = firstDay
                } else {
                    self.workoutDay = nil
                }

                if self.viewState == .loading || self.viewState == .fetching || self.viewState == .updating {
                    if workoutWeekEntities.isEmpty {
                        self.viewState = .idle
                    } else {
                        self.viewState = .idle
                    }
                } else if workoutWeekEntities.isEmpty && self.workoutDay == nil {
                    self.viewState = .idle
                }
            }
            .store(in: &cancellables)
    }

    func getWorkoutPlan() async  {
        switch viewState {
            case .loading, .fetching, .updating:
                return
            default:
                break
        }

        viewState = .loading
        
        do {
            _ = try await workoutPlanUseCase.execute()
            
            if viewState == .loading {
                viewState = .idle
            }
        } catch {
            FSLogger.error("Failed to get workout plan: \(error.localizedDescription)")
            viewState = .error(error)
        }
    }
    
    func saveWorkoutRoutine() async {
        guard let workoutWeek = workoutWeek, let workoutDay else { return }

        if let index = workoutDays.firstIndex(where: { $0.id == workoutDay.id }) {
            workoutDays[index] = workoutDay
        }
        
        do {
            try await updateRoutineUseCase.execute(week: workoutWeek.week, days: workoutDays.map({ $0.toEntity() }))
        } catch {
            FSLogger.error("Failed to save workout routine: \(error.localizedDescription)")
        }
    }
}
