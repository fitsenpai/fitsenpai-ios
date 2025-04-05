//
//  WorkoutsMainView.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/22/24.
//

import SwiftUI
import BottomSheet

struct WorkoutsMainView: View {
    @StateObject var viewModel: WorkoutsMainViewModel
    @State private var showingDetail = false
    @State private var feedbackType: WorkoutSheetType?
    @State private var selectedDate: Date = Date() {
        didSet {
            if let uuid = globalAppEnvObject.user?.id {
                viewModel.fetchWorkoutPlans(forUser: uuid, date: selectedDate)
            }
        }
    }
    @State private var currentWeekStartDate: Date = Date()
    
    var body: some View {
        VStack(alignment: .leading) {
            FSNavBarView()
                .padding(.horizontal, 12)
            
            SwipeableCalendarView(selectedDate: $selectedDate, currentWeekStartDate: $currentWeekStartDate)
            
            if let upcomingWeekNumber = viewModel.upNextWeekNumber {
                newWeekView(weekNumber: upcomingWeekNumber)
            } else {
                WorkoutListSection(
                    viewModel: viewModel,
                    showingDetail: $showingDetail,
                    feedbackType: $feedbackType
                )
                .padding(.horizontal, 12)
            }
        }
        .padding(.horizontal, 12)
        .onAppear(perform: fetchInitialData)
        .onChange(of: selectedDate) { _, newValue in
            fetchWorkoutPlans(for: newValue)
        }
        .onChange(of: currentWeekStartDate) { _, newValue in
            fetchWeeklyPlan(for: newValue)
        }
        .sheet(item: $feedbackType, content: { type in
            switch type {
            case .negative:
                NegativeFeedbackSheet(feedbackType: $feedbackType)
                    .flexibleSheet()
                    .background(.thickMaterial)
            case .positive, .negativeInput:
                NegativeFeedbackInoutSheet()
                    .flexibleSheet()
                    .background(.thickMaterial)
            case .changeWorkout:
                ChangeWorkoutSheetSheet()
                    .flexibleSheet()
                    .background(.thickMaterial)
            }
        })
    }
    
    private func newWeekView(weekNumber: Int) -> some View {
        VStack {
            BackgroundInfoView(
                viewModel: BackgroundInfoViewModel(
                    iconName: "ic_calendar_check",
                    iconTint: .fsPrimary,
                    title: "Week \(weekNumber) is now unlocked",
                    mainLabel: "Tap below to generate your new workout and\nmeal plans. This may take a few minutes.",
                    buttonLabel: "Generate plans",
                    buttonAction: {}
                )
            )
            .padding(.top, 20)
            Spacer()
        }
    }
    
    private func fetchInitialData() {
        if let uuid = globalAppEnvObject.user?.id {
            viewModel.fetchWorkoutPlans(forUser: uuid, date: selectedDate)
        }
    }
    
    private func fetchWorkoutPlans(for date: Date) {
        if let uuid = globalAppEnvObject.user?.id {
            viewModel.fetchWorkoutPlans(forUser: uuid, date: date)
        }
    }
    
    private func fetchWeeklyPlan(for date: Date) {
        if let uuid = globalAppEnvObject.user?.id {
            viewModel.fetchWeeklyPlan(forUser: uuid, date: date)
        }
    }
    
    static func create() -> WorkoutsMainView {
        let repo = WorkoutRepoImpl(client: FSClient.shared!)
        let useCase = WorkoutUseCase(workoutRepo: repo)
        let viewModel = WorkoutsMainViewModel(workoutUseCase: useCase)
        return WorkoutsMainView(viewModel: viewModel)
    }
}

#Preview {
    WorkoutsMainView.create()
}
