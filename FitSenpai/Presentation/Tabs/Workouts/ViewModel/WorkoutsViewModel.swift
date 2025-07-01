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
class WorkoutsViewModel: ObservableObject, HandlesErrors {
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
    
    @Published var isPendingGeneration = false

    @Inject private var workoutDataStore: WorkoutDataStore
    @Inject private var workoutPlanUseCase: WorkoutPlanUseCaseProtocol
    @Inject private var updateRoutineUseCase: UpdateRoutineUseCaseProtocol
    @Inject private var generateWorkoutUseCase: GenerateWorkoutUseCaseProtocol
    @Inject private var regenerateWorkoutUseCase: RegenerateWorkoutUseCaseProtocol

    private var cancellables = Set<AnyCancellable>()
    var animatedDailyProgress: Double  = 0
    
    private var isCheckingStatus = false

    init() {
        Task {
            await getWorkoutPlan()
        }
    }
    
}

// MARK: - Workout Data Handling
extension WorkoutsViewModel {
  
    func getWorkoutPlan() async  {
        do {
            self.workoutWeeks = try await workoutPlanUseCase.execute()
            self.updateSelectedWorkoutData(for: Date())
            self.viewState = .idle
        } catch {
            self.viewState = .idle
        }
    }
    
    func checkWorkoutGenerationStatus() async {
        // Prevent multiple simultaneous calls
        guard !isCheckingStatus else { return }
        isCheckingStatus = true
        defer { isCheckingStatus = false }
        
        do {
            let updatedWorkoutWeeks = try await workoutPlanUseCase.execute()
            self.workoutWeeks = updatedWorkoutWeeks
            
            let currentDate = CalendarDataManager.shared.selectedDate
            self.updateSelectedWorkoutData(for: currentDate)
            
        } catch {
            FSLogger.error("Failed to check workout generation status: \(error.localizedDescription)")
            // Don't update viewState here as this is background polling
        }
    }
    
    func generateWorkoutPlan(date: Date) async  {
        viewState = .fetching
        do {
            let selectedDate = date.toString(WithFormat: "yyyy-MM-dd")
            let workoutWeek = try await generateWorkoutUseCase.execute(date: selectedDate)
            updateOrAddWorkoutWeek(workoutWeek)
            self.updateSelectedWorkoutData(for: date)
            self.viewState = .idle
        } catch {
            FSLogger.error("Failed to generate workout plan: \(error.localizedDescription)")
            viewState = .error(error)
        }
    }
    
    func regenerateWorkoutPlan(date: Date, instruction: String) async  {
        viewState = .fetching
        do {
            let selectedDate = date.toString(WithFormat: "yyyy-MM-dd")
            let workoutDay = try await regenerateWorkoutUseCase.execute(date: selectedDate, instruction: instruction)
            updateWorkoutDay(workoutDay, for: selectedDate)
            self.updateSelectedWorkoutData(for: date)
            self.viewState = .idle
        } catch {
            FSLogger.error("Failed to regenerate workout plan: \(error.localizedDescription)")
            viewState = .error(error)
        }
    }

    func updateSelectedWorkoutData(for date: Date) {
        if let dayType = WeekDayType(rawValue: date.dayName.lowercased()) {
            self.selectedDay = dayType
        }
        
        if SuperwallManager.shared.isTrialActive {
            self.selectedWorkoutWeek = workoutWeeks.first
            self.selectedWorkoutDay = self.selectedWorkoutWeek?.days.first
            self.routines = selectedWorkoutDay?.routinesSorted().routines ?? []
            self.isPendingGeneration = selectedWorkoutDay?.pendingGeneration ?? false
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
            self.isPendingGeneration = selectedWorkoutDay?.pendingGeneration ?? false
            self.updateDailyProgress()
        } else {
            self.selectedWorkoutDay = nil
            self.isPendingGeneration = false
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
    

    func onToggleCompleted(for date: String, name: String) async {
        triggerHaptics()
        do {
            try await updateRoutineUseCase.execute(date: date, name: name)
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

private extension WorkoutsViewModel {

    private func updateOrAddWorkoutWeek(_ workoutWeek: WeekPlan<WorkoutDay>) {
        if let index = findWeekIndex(by: workoutWeek.startDate, endDate: workoutWeek.endDate) {
            self.workoutWeeks[index] = workoutWeek
        } else {
            self.workoutWeeks.append(workoutWeek)
        }
    }

    private func updateWorkoutDay(_ workoutDay: WorkoutDay, for selectedDate: String) {
        guard let weekIndex = findWeekIndex(containing: selectedDate) else { return }
        
        if let dayIndex = findDayIndex(in: weekIndex, matching: workoutDay.date) {
            self.workoutWeeks[weekIndex].days[dayIndex] = workoutDay
        } else {
            self.workoutWeeks[weekIndex].days.append(workoutDay)
        }
    }

    private func findWeekIndex(by startDate: String, endDate: String) -> Int? {
        return self.workoutWeeks.firstIndex { weekPlan in
            weekPlan.startDate == startDate && weekPlan.endDate == endDate
        }
    }

    private func findWeekIndex(containing date: String) -> Int? {
        return self.workoutWeeks.firstIndex { weekPlan in
            date >= weekPlan.startDate && date <= weekPlan.endDate
        }
    }

    private func findDayIndex(in weekIndex: Int, matching date: String) -> Int? {
        return self.workoutWeeks[weekIndex].days.firstIndex { $0.date == date }
    }

}
