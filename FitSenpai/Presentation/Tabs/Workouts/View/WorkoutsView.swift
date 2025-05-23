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
    @EnvironmentObject var mainViewModel: MainViewModel
    @StateObject private var viewModel: WorkoutsViewModel = .init()
    
    // @State private var isLoaded: Bool = false
    
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
            buttonAction: {
                triggerHaptics()
            }
        )
    }
    
    var readyViewModel: FSInfoViewModel {
        .init(
            iconName: "icon_sparkle_green",
            iconTint: .fsAccentForeground,
            iconBackground: .fsAccent,
            title: "Your workout plan is ready!",
            mainLabel: "Tap below to generate your new workouts\nfor the week",
            buttonLabel: "Generate workouts",
            buttonAction: {
                Task {
                    await viewModel.getWorkoutPlan()
                    // The mainViewModel.progressData and highlightedDays logic might need reconsideration
                    // as getWorkoutPlan now populates the ViewModel directly from the store.
                    // If this was for calendar highlighting, it needs a new source or to be removed.
                    // For now, I'll comment it out as its source data (generateWorkoutPlan) is gone.
                    // let (progressData, days) = await viewModel.generateWorkoutPlan()
                    // mainViewModel.progressData = progressData
                    // mainViewModel.highlightedDays = days
                }
                triggerHaptics()
            }
        )
    }

    func errorViewModel(error: Error) -> FSInfoViewModel {
        .init(
            iconName: "exclamationmark.triangle.fill", // Or some other error icon
            iconTint: .red,
            iconBackground: .gray.opacity(0.2),
            title: "An Error Occurred",
            mainLabel: error.localizedDescription,
            buttonLabel: "Retry",
            buttonAction: {
                Task {
                    await viewModel.getWorkoutPlan()
                }
                triggerHaptics()
            }
        )
    }
    
    var body: some View {
        MainContainerView {
            VStack(alignment: .leading) {
                switch viewModel.viewState {
                case .loading, .fetching, .updating: // Consider .fetching and .updating as loading too
                    FSInfoView(viewModel: generatingViewModel)
                        .padding(.vertical, 12)
                case .idle:
                    if let workoutDay = viewModel.workoutDay, !workoutDay.routines.isEmpty {
                        WorkoutDaysView(viewModel: viewModel)
                    } else {
                        // This implies no workout data, show the "ready to generate" view
                        FSInfoView(viewModel: readyViewModel)
                    }
                case .error(let error):
                    FSInfoView(viewModel: errorViewModel(error: error))
                        .padding(.vertical, 12)
                default: // Handle other states like .uploading if necessary, or fallback
                    Text("Unhandled view state.")
                }
                Spacer()
            }
            .onChange(of: mainViewModel.selectedDate) { _, newValue in
                // MARK: TODO - Implement logic for date change if needed
                // This might involve telling the viewModel to select a different day/week
            }
            .onChange(of: mainViewModel.currentWeekStartDate) { _, newValue in
                // MARK: TODO - Implement logic for week change if needed
                // This might involve telling the viewModel to fetch data for the new week
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
    
    // private func fetchInitialData() {
    //     Task {
    //         await viewModel.getWorkoutPlan()
    //     }
    // }
}
