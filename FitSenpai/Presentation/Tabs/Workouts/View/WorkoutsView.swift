//
//  WorkoutsMainView.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/22/24.
//

import SwiftUI
import BottomSheet
import CoreKit

struct WorkoutsView: View {
    @EnvironmentObject private var superwall: SuperwallManager
    // @EnvironmentObject var mainViewModel: MainViewModel
    @StateObject private var viewModel: WorkoutsViewModel = .init()
    @StateObject private var calendarManager = CalendarDataManager.shared
    
    var generatingViewModel: FSInfoViewModel {
        .init(
            iconName: nil,
            title: "Generating workouts...",
            mainLabel: "This won’t take long. Please don’t exit.",
            buttonLabel: "",
            containerHeight: .infinity,
            showButton: false,
            isLoading: true,
            buttonAction: {
                triggerHaptics()
            }
        )
    }

    func errorViewModel(error: Error) -> FSInfoViewModel {
        .init(
            iconName: .iconBoxWarning,
            title: "An Error Occurred",
            mainLabel: error.localizedDescription,
            buttonLabel: "Retry",
            buttonAction: {
                Task {
                    await viewModel.getWorkoutPlan()
                    viewModel.updateSelectedWorkoutData(for: calendarManager.selectedDate)
                }
                triggerHaptics()
            }
        )
    }
    
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
        MainContainerView {
            VStack(alignment: .leading) {
                switch viewModel.viewState {
                case .loading:
                    ShimmerWorkoutWeekView()
                case .updating:
                    FSInfoView(viewModel: generatingViewModel)
                        .padding(.vertical, 12)
                case .idle:
                    if let selectedWeek = viewModel.selectedWorkoutWeek {
                        WorkoutWeekView(workoutWeek: selectedWeek)
                            .environmentObject(viewModel)
                    } else {
                        FSInfoView(viewModel: planUnavailable)
                            .padding(.vertical, 12)
                    }
                case .error(let error):
                    FSInfoView(viewModel: errorViewModel(error: error))
                        .padding(.vertical, 12)
                default:
                    Text("Unhandled view state.")
                }
                Spacer()
            }
            .onReceive(calendarManager.$selectedDate, perform: { date in
                viewModel.updateSelectedWorkoutData(for: date)
            })
            .onReceive(viewModel.$workoutWeeks, perform: { weeks in
                configureCalendar(with: weeks)
            })
            .sheet(item: $viewModel.activeSheet, content: { type in
                switch type {
                case .changeWorkout:
                    ChangeWorkoutSheetSheet()
                        .flexibleSheet()
                        .background(.white)
                        .presentationCornerRadius(32)
                }
            })
            // This helps if the view appears after the initial data load.
            .onAppear {
                if !viewModel.workoutWeeks.isEmpty {
                     viewModel.updateSelectedWorkoutData(for: calendarManager.selectedDate)
                }
            }
        }
    }
    
    private func configureCalendar(with weeks: [WeekPlan<WorkoutDay>]) {
        if !weeks.isEmpty,
           let firstWeekStartDateString = weeks.min(by: { 
               $0.startDate.toDate(format: "yyyy-MM-dd") ?? Date.distantFuture <
               $1.startDate.toDate(format: "yyyy-MM-dd") ?? Date.distantFuture
           })?.startDate,
           let overallStartDate = firstWeekStartDateString.toDate(format: "yyyy-MM-dd") {

            let overallEndDate = weeks.max(by: {
                $0.endDate.toDate(format: "yyyy-MM-dd") ?? Date.distantPast <
                $1.endDate.toDate(format: "yyyy-MM-dd") ?? Date.distantPast
            })?.endDate.toDate(format: "yyyy-MM-dd") ?? Date()

            let currentDateToMaintain = calendarManager.selectedDate
            calendarManager.configure(startDate: overallStartDate, endDate: max(overallEndDate, Date()))
            calendarManager.selectedDate = currentDateToMaintain

        } else {
            calendarManager.configure(startDate: Date(), endDate: Date())
        }

        viewModel.updateSelectedWorkoutData(for: calendarManager.selectedDate)
    }
}
