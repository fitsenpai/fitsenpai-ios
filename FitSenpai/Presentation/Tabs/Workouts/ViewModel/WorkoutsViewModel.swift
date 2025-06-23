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
    @Published var selectedWorkoutWeek: WeekPlan<WorkoutDay>?
    @Published var selectedWorkoutDay: WorkoutDay?
    @Published var routines: [WorkoutRoutine] = []
    @Published var selectedRoutine: WorkoutRoutine?
    @Published var showingDetail = false
    @Published var showRateApp = false
    @Published var selectedDay: WeekDayType = .monday

    @Inject private var workoutPlanUseCase: WorkoutPlanUseCaseProtocol
    @Inject private var workoutDataStore: WorkoutDataStore
    @Inject private var updateRoutineUseCase: UpdateRoutineUseCaseProtocol

    private var cancellables = Set<AnyCancellable>()
    var animatedDailyProgress: Double  = 0

    init() {
        Task {
            await getWorkoutPlan()
        }
    }
    
}

// MARK: - Workout Data Handling
extension WorkoutsViewModel {
  
    func getWorkoutPlan() async  {
        viewState = .loading
        defer { viewState = .idle }
        do {
            self.workoutWeeks = try await workoutPlanUseCase.execute()
            self.updateSelectedWorkoutData(for: Date())
        } catch {
            FSLogger.error("Failed to get workout plan: \(error.localizedDescription)")
            viewState = .error(error)
        }
    }

    func updateSelectedWorkoutData(for date: Date) {
        if let dayType = WeekDayType(rawValue: date.dayName.lowercased()) {
            self.selectedDay = dayType
        }
        
        if SuperwallManager.shared.isFirstDayTrialActive {
            self.selectedWorkoutWeek = workoutWeeks.first
            self.selectedWorkoutDay = self.selectedWorkoutWeek?.days.first
            self.routines = selectedWorkoutDay?.routinesSorted().routines ?? []
            self.updateDailyProgress()
            return
        }
        
        let targetWeek = workoutWeeks.first { weekPlan in
            guard let weekStartDate = weekPlan.startDate.toDate(format: nil)?.startOfDay,
                  let weekEndDate = weekPlan.endDate.toDate(format: nil)?.startOfDay,
                  let nextDayAfterWeekEndDate = Calendar.current.date(byAdding: .day, value: 1, to: weekEndDate) else {
                return false
            }
            return date.startOfDay >= weekStartDate && date.startOfDay < nextDayAfterWeekEndDate
        }
        
        self.selectedWorkoutWeek = targetWeek
        
        if let week = targetWeek, let dayType = WeekDayType(rawValue: date.dayName.lowercased()) {
            self.selectedWorkoutDay = week.days.first { $0.day.lowercased() == dayType.rawValue }
            self.routines = selectedWorkoutDay?.routinesSorted().routines ?? []
            self.updateDailyProgress()
        } else {
            self.selectedWorkoutDay = nil
        }
    }
    
    func updateDailyProgress() {
        guard !routines.isEmpty else { return }
        
        let completedCount = routines.filter({ $0.isCompleted }).count
        let progress = Double(completedCount) / Double(routines.count)
        let validProgress = progress.isNaN ? 0.0 : progress
        withAnimation {
            self.animatedDailyProgress = validProgress
        }
    }
    

    func onToggleCompleted(id: String) async {
        triggerHaptics()
        do {
            try await updateRoutineUseCase.execute(id)
            self.updateDailyProgress()
            self.objectWillChange.send()
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
