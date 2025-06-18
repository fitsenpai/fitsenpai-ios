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
    
    var body: some View {
        VStack(spacing: 16) {
            FSSectionHeaderView(text: "Workouts") {
                triggerHaptics()
                if superwall.isFirstDayTrialActive {
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

    var workoutDay: WorkoutDay
    
    var body: some View {
        VStack(spacing: 16) {
            if workoutDay.pendingGeneration {
                FSInfoView(viewModel: .init(
                    iconName: .iconBoxSparcle,
                    title: "Your workout plan is ready!",
                    mainLabel: "Tap below to generate your new workouts\nfor the week",
                    buttonLabel: "Generate workouts",
                    buttonAction: {
                        triggerHaptics()
                    }
                ))
            } else {
                if workoutDay.routines.isEmpty {
                    FSInfoView(viewModel: .init(
                        iconName: .iconBoxHeart,
                        title: "Rest day",
                        mainLabel: "Your body’s recharging. Recovery is part of \nthe process — you’ve earned this.",
                        buttonLabel: "I want to stay active",
                        buttonAction: {
                            triggerHaptics()
                        }
                    ))
                } else {
                    FSCompletionBarView(titleText: workoutDay.title, progress: viewModel.animatedDailyProgress)
                    WorkoutRoutinesView()
                }
            }
        }
    }
}
