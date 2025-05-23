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
                
                let newWorkoutWeeks = workoutWeekEntities.map { $0.toDomain() }
                
                // Attempt to reconcile existing workoutDay's routines to preserve instances
                if let currentWorkoutDay = self.workoutDay,
                   let correspondingNewWeek = newWorkoutWeeks.first(where: { $0.week == self.workoutWeek?.week }), // Assuming WeekPlan has a 'week' identifier
                   let correspondingNewDay = correspondingNewWeek.days.first(where: { $0.id == currentWorkoutDay.id }) {
                    
                    // Check if routines structure is largely the same (same count, same IDs in order)
                    // This is a simplification; robust reconciliation is more complex.
                    if currentWorkoutDay.routines.count == correspondingNewDay.routines.count &&
                       zip(currentWorkoutDay.routines, correspondingNewDay.routines).allSatisfy({ $0.id == $1.id }) {
                        
                        // Update existing routine instances in place
                        for i in 0..<currentWorkoutDay.routines.count {
                            // Only update properties that might change, like isCompleted
                            // This assumes other properties (name, gifUrl etc.) are stable or handled by full refresh
                            currentWorkoutDay.routines[i].isCompleted = correspondingNewDay.routines[i].isCompleted
                            // Add other properties if they can change and need updating without full instance replacement
                            // e.g., currentWorkoutDay.routines[i].name = correspondingNewDay.routines[i].name
                        }
                        // Manually trigger objectWillChange if WorkoutDay is not ObservableObject
                        // and its direct properties haven't changed reference.
                        // This tells SwiftUI that workoutDay (which is @Published) has had internal changes.
                        // Or, if dailyProgress calculation will trigger it, this might not be needed.
                        // self.objectWillChange.send() // Could use this if @Published workoutDay doesn't detect internal array changes well enough
                        // Forcing a re-assignment to ensure @Published fires for the workoutDay content change:
                        self.workoutDay = currentWorkoutDay // Re-assign to publish (even if same instance, its content changed)

                        // Also update self.workoutDays and self.workoutWeek if necessary by finding and updating the day within them.
                        if let weekIdx = self.workoutWeeks.firstIndex(where: { $0.week == correspondingNewWeek.week }) {
                            if let dayIdx = self.workoutWeeks[weekIdx].days.firstIndex(where: { $0.id == currentWorkoutDay.id }) {
                                // This assignment might be tricky if WorkoutDay is a class.
                                // We've modified currentWorkoutDay (which is self.workoutDay).
                                // If self.workoutDays[dayIdx] pointed to the same instance, it's already updated.
                                // If not, we need to ensure self.workoutDays[dayIdx] is also this updated instance.
                                // For simplicity, if workoutDay is the primary driver, this might be enough if other views
                                // derive from workoutDay.
                            }
                        }
                        // This simplified reconciliation might not update self.workoutWeeks / self.workoutDays correctly if they are distinct copies.
                        // The full replacement below is safer for now if this reconciliation is too complex.
                        // So, we'll fall back to full replacement if this light reconciliation doesn't cover all cases.
                         FSLogger.debug("WorkoutsViewModel: Performed light reconciliation for routines.")

                    } else {
                        // Structure changed, do full replacement
                        FSLogger.debug("WorkoutsViewModel: Routine structure changed, performing full replacement.")
                        self.workoutWeeks = newWorkoutWeeks
                        self.workoutWeek = self.workoutWeeks.first
                        self.workoutDays = self.workoutWeek?.days ?? []
                        self.workoutDay = self.workoutDays.first?.routinesSorted()
                    }
                } else {
                    // No current workoutDay or couldn't find corresponding new day, do full replacement
                    FSLogger.debug("WorkoutsViewModel: No current workout day or correspondence, performing full replacement.")
                    self.workoutWeeks = newWorkoutWeeks
                    self.workoutWeek = self.workoutWeeks.first
                    self.workoutDays = self.workoutWeek?.days ?? []
                    self.workoutDay = self.workoutDays.first?.routinesSorted()
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

extension WorkoutDay {
    func routinesSorted() -> Self {
        self.routines.sort(by: { $0.sortIndex < $1.sortIndex })
        return self
    }
}
