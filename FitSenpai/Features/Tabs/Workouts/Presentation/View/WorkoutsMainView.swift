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
    
    init() {
        let repo = WorkoutRepoImpl(client: FSClient.shared!)
        let useCase = WorkoutUseCase(workoutRepo: repo)
        let viewModel = WorkoutsMainViewModel(workoutUseCase: useCase)
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var generatingViewModel: GeneralInfoViewModel {
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
    
    var readyViewModel: GeneralInfoViewModel {
        .init(
            iconName: "icon_sparkle",
            iconTint: .fsAccentForeground,
            iconBackground: .fsAccent,
            title: "Your workout plan is ready!",
            mainLabel: "Tap below to generate your new workouts\nfor the week",
            buttonLabel: "Generate workouts",
            buttonAction: {
                Task {
                    let (progressData, days) = await viewModel.generateWorkputPlan()
                    mainViewModel.progressData = progressData
                    mainViewModel.highlightedDays = days
                }
            }
        )
    }
    
    var body: some View {
        MainContainerView {
            VStack(alignment: .leading) {
                if viewModel.showGeneratePlan {
                    GeneralInfoView(viewModel: viewModel.isWorkoutLoading ? generatingViewModel : readyViewModel)
                    .padding(.vertical, 12)
                    Spacer()
                } else {
                    WorkoutListSection(viewModel: viewModel)
                }
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
                        .background(.thickMaterial)
                }
            })
        }
    }
    
    private func fetchInitialData() {
        if let uuid = globalAppEnvObject.user?.id {
            viewModel.fetchWorkoutPlans(forUser: uuid, date: mainViewModel.selectedDate)
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
