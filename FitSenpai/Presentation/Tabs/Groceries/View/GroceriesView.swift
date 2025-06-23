//
//  GroceriesMainView.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/22/24.
//

import SwiftUI

struct GroceriesView: View {
    @EnvironmentObject private var superwall: SuperwallManager
    @StateObject private var viewModel: GroceryViewModel = .init()
    @StateObject private var calendarManager = CalendarDataManager.shared
    
    var generatingViewModel: FSInfoViewModel {
        .init(
            iconName: nil,
            title: "Generating grocery list...",
            mainLabel: "This won't take long. Please don't exit.",
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
            iconName: .iconBoxSparcle,
            title: "Your grocery list is ready!",
            mainLabel: "Tap below to generate your grocery list\nfor the week",
            buttonLabel: "Generate list",
            buttonAction: {
                Task {
                    await viewModel.getGroceryPlan()
                }
                triggerHaptics()
            }
        )
    }
    
    var body: some View {
        MainContainerView {
            VStack(alignment: .leading, spacing: 20) {
                switch viewModel.viewState {
                case .loading:
                    if viewModel.shoppingCategoryList.isEmpty {
                        ShimmerGroceriesView()
                    } else {
                        FSInfoView(viewModel: generatingViewModel)
                            .padding(.vertical, 12)
                    }
                case .fetching, .updating:
                    FSInfoView(viewModel: generatingViewModel)
                        .padding(.vertical, 12)
                case .idle:
                    if !viewModel.shoppingCategoryList.isEmpty {
                        contentView
                        groceryListView
                    } else {
                        FSInfoView(viewModel: readyViewModel)
                        Spacer()
                    }
                case .error(let error):
                    FSInfoView(viewModel: errorInfoViewModel(error: error))
                        .padding(.vertical, 12)
                default:
                    Text("Unhandled view state.")
                }
            }
            .onReceive(calendarManager.$selectedDate, perform: { date in
                viewModel.updateSelectedGroceryData(for: date)
            })
            .onReceive(viewModel.$groceryWeeks, perform: { weeks in
                configureCalendar(with: weeks)
            })
            // This helps if the view appears after the initial data load.
            .onAppear {
                if !viewModel.groceryWeeks.isEmpty {
                     viewModel.updateSelectedGroceryData(for: calendarManager.selectedDate)
                }
            }
        }
    }
    
    func errorInfoViewModel(error: Error) -> FSInfoViewModel {
        .init(
            iconName: .iconBoxWarning,
            title: "Error Generating List",
            mainLabel: error.localizedDescription,
            buttonLabel: "Retry",
            buttonAction: {
                Task {
                    await viewModel.getGroceryPlan()
                }
                triggerHaptics()
            }
        )
    }
    
    var contentView: some View {
        VStack(spacing: 16) {
            FSSectionHeaderView(text: "Groceries", showGenerateButton: false) {
                triggerHaptics()
                if superwall.isFirstDayTrialActive {
                    superwall.presentPaywall(for: .proContent)
                }
            }
            FSCompletionBarView(titleText: viewModel.totalCount, progress: viewModel.selectionProgress)
            FSCard(backgroundColor: .fsAccent) {
                viewModel.dateRangeText
                .font(.body12)
                .frame(maxWidth: .infinity)
                .foregroundStyle(Color.fsMutedForeground)
                .lineSpacing(3)
            }
        }
    }
    
    var groceryListView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                ForEach($viewModel.shoppingCategoryList) { $category in
                    GroceriesSectionView(
                        shoppingCategory: $category
                    )
                    .modifier(onReceiveItems(category.items))
                }
            }
            .padding(.horizontal, 1)
        }
        .scrollIndicators(.hidden)
    }
    
    private func configureCalendar(with weeks: [GroceryWeek]) {
        if !weeks.isEmpty,
           let firstWeekStartDateString = weeks.min(by: { $0.week < $1.week })?.startDate,
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

        viewModel.updateSelectedGroceryData(for: calendarManager.selectedDate)
    }
}

private extension GroceriesView {
    func onReceiveItems(_ items: [GroceryItem]) -> some ViewModifier {
        return OnReceiveItemsModifier(items: items) { _ in
            viewModel.recalculateProgress()
        }
    }
}
