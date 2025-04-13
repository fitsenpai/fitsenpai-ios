//
//  WorkoutsMainView.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/22/24.
//

import SwiftUI
import BottomSheet

struct WorkoutsMainView: View {
    @EnvironmentObject var mainViewModel: MainViewModel
    @StateObject private var viewModel: WorkoutsMainViewModel
    @AppState(\.isLimited) private var isLimitedAccess: Bool
    
    @State private var isLoaded: Bool = false

    init() {
        let repo = WorkoutRepoImpl(client: FSClient.shared!)
        let useCase = WorkoutUseCase(workoutRepo: repo)
        let viewModel = WorkoutsMainViewModel(workoutUseCase: useCase)
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var generatingViewModel: FSInfoViewModel {
        .init(
            iconName: "",
            iconTint: .fsAccentForeground,
            iconBackground: .fsAccent,
            title: "Generating workouts...",
            mainLabel: "This won’t take long. Please don’t exit.",
            buttonLabel: "",
            containerHeight: .infinity,
            showButton: false,
            isLoading: true,
            buttonAction: { }
        )
    }
    
    var readyViewModel: FSInfoViewModel {
        .init(
            iconName: "icon_sparkle",
            iconTint: .fsAccentForeground,
            iconBackground: .fsAccent,
            title: "Your workout plan is ready!",
            mainLabel: "Tap below to generate your new workouts\nfor the week",
            buttonLabel: "Generate workouts",
            buttonAction: {
                Task {
                    let (progressData, days) = await viewModel.generateWorkoutPlan()
                    mainViewModel.progressData = progressData
                    mainViewModel.highlightedDays = days
                }
            }
        )
    }
    
    var body: some View {
        MainContainerView {
            VStack(alignment: .leading) {
                if viewModel.isWorkoutLoading {
                    FSInfoView(viewModel: generatingViewModel)
                    .padding(.vertical, 12)
                } else {
                    if viewModel.showGeneratePlan {
                        FSInfoView(viewModel: readyViewModel)
                    } else {
                        WorkoutListSection(viewModel: viewModel)
                    }
                }
                Spacer()
            }
            .onAppear(perform: fetchInitialData)
            .onChange(of: mainViewModel.selectedDate) { _, newValue in
                fetchWorkoutPlans(for: newValue)
            }
            .onChange(of: mainViewModel.currentWeekStartDate) { _, newValue in
                fetchWeeklyPlan(for: newValue)
            }
            .sheet(item: $viewModel.activeSheet, content: { type in
                switch type {
                case .changeWorkout:
                    ChangeWorkoutSheetSheet()
                        .flexibleSheet()
                        .background(.white)
                        .presentationCornerRadius(32)
                }
            })
        }
    }
    
    private func fetchInitialData() {
        guard !isLoaded else { return }
        isLoaded = true
        if isLimitedAccess {
            Task {
                let (progressData, days) = await viewModel.getLimitedWorkoutPlan()
                mainViewModel.progressData = progressData
                mainViewModel.highlightedDays = days
            }
        } else {
            viewModel.showGeneratePlan = true
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
}
