//
//  WorkoutDaysView.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/3/25.
//

import SwiftUI


struct WorkoutWeekView: View {
    @EnvironmentObject private var superwall: SuperwallManager
    @EnvironmentObject private var viewModel: WorkoutsViewModel
    @StateObject private var calendarManager = CalendarDataManager.shared
    var workoutWeek: WeekPlan<WorkoutDay>
    
    var planUnavailable: FSInfoViewModel {
        .init(
            iconName: .iconBoxWarning,
            title: "Plan unavailable for this week",
            mainLabel: "You have no active subscription\nduring this time.",
            buttonLabel: "",
            showButton: false,
            isLoading: false,
            buttonAction: {
                
            }
        )
    }
    
    private var shouldShowGenerateButton: Bool {
        let selectedDate = calendarManager.selectedDate
        let currentWeekStart = Calendar.current.dateInterval(of: .weekOfYear, for: Date())?.start ?? Date()
        let selectedWeekStart = Calendar.current.dateInterval(of: .weekOfYear, for: selectedDate)?.start ?? selectedDate
        
        return selectedWeekStart >= currentWeekStart
    }
    
    var body: some View {
        VStack(spacing: 16) {
            FSSectionHeaderView(category: .workout, showGenerateButton: shouldShowGenerateButton) {
                triggerHaptics()
                if superwall.isTrialActive {
                    superwall.presentPaywall(for: .proContent)
                } else {
                    viewModel.activeSheet = .changeWorkout
                }
            }
            
            if let workoutDay = viewModel.selectedWorkoutDay {
                WorkoutDayView(workoutDay: workoutDay)
            } else {
                FSInfoView(viewModel: planUnavailable)
            }
        }
    }
}

struct WorkoutDayView: View {
    @EnvironmentObject private var viewModel: WorkoutsViewModel
    @StateObject private var calendarManager = CalendarDataManager.shared
    @State private var pollingTimer: Timer?

    var workoutDay: WorkoutDay
    
    var body: some View {
        VStack(spacing: 16) {
            if viewModel.isPendingGeneration {
                pendingGenerationView
            } else {
                if workoutDay.routines.isEmpty {
                    FSInfoView(viewModel: .init(
                        iconName: .iconBoxHeart,
                        title: "Rest day",
                        mainLabel: "Your body's recharging. Recovery is part of \nthe process — you've earned this.",
                        buttonLabel: "I want to stay active",
                        buttonAction: {
                            triggerHaptics()
                            Task {
                                await viewModel.regenerateWorkoutPlan(date: calendarManager.selectedDate, instruction: "")
                            }
                        }
                    ))
                } else {
                    FSCompletionBarView(titleText: workoutDay.title, progress: viewModel.animatedDailyProgress)
                    WorkoutRoutinesView()
                }
            }
        }
        .onChange(of: viewModel.isPendingGeneration) { _, isPending in
            if isPending {
                startPolling()
            } else {
                stopPolling()
            }
        }
        .onAppear {
            if viewModel.isPendingGeneration {
                startPolling()
            }
        }
        .onDisappear {
            stopPolling()
        }
    }
    
    private func startPolling() {
        stopPolling()
        pollingTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
            Task {
                await viewModel.checkWorkoutGenerationStatus()
            }
        }
    }
    
    private func stopPolling() {
        pollingTimer?.invalidate()
        pollingTimer = nil
    }
    
    var pendingGenerationView: some View {
        FSInfoView(viewModel: .init(
            iconName: nil,
            title: "Generating workouts...",
            mainLabel: "This won’t take long. Please don’t exit.",
            buttonLabel: "",
            containerHeight: .infinity,
            showButton: false,
            isLoading: true,
            buttonAction: { }
        ))
    }
}
