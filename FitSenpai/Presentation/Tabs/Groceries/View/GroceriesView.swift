//
//  GroceriesMainView.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/22/24.
//

import SwiftUI

struct GroceriesView: View {
    @EnvironmentObject private var superwall: SuperwallManager
    @ObservedObject var viewModel: MealsViewModel
    @StateObject private var calendarManager = CalendarDataManager.shared
    @State private var pollingTimer: Timer?
    
    @AppState(\.didSubscribedWithoutUserID) private var didSubscribedWithoutUserID: Bool

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
                    await viewModel.generateMealPlan(date: calendarManager.selectedDate)
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
                    if viewModel.isGroceryGenerationPending {
                        FSInfoView(viewModel: generatingViewModel)
                            .padding(.vertical, 12)
                    } else if !viewModel.shoppingCategoryList.isEmpty {
                        contentView
                        groceryListView
                    } else {
                        FSInfoView(viewModel: readyViewModel)
                        Spacer()
                    }
                case .error(let error):
                    FSInfoView(viewModel: errorInfoViewModel(error: error))
                        .padding(.vertical, 12)
                    Spacer()
                default:
                    EmptyView()
                }
            }
            .onReceive(calendarManager.$selectedDate, perform: { date in
                viewModel.updateSelectedData(for: date)
            })
            // This helps if the view appears after the initial data load.
            .onAppear {
                if !viewModel.groceryWeeks.isEmpty {
                     viewModel.updateSelectedData(for: calendarManager.selectedDate)
                }
            }
            .onChange(of: viewModel.shouldPollGroceries) { _, shouldPoll in
                if shouldPoll {
                    startGroceryPollingIfNeeded()
                } else {
                    stopGroceryPolling()
                }
            }
            .onChange(of: viewModel.viewState) { _, newState in
                if case .idle = newState, viewModel.shouldPollGroceries {
                    startGroceryPollingIfNeeded()
                }
            }
            .onChange(of: didSubscribedWithoutUserID, { _, didSubscribedWithoutUserID in
                if didSubscribedWithoutUserID {
                    viewModel.groceryWeeks.removeAll()
                    viewModel.updateSelectedGroceryData(for: Date())
                }
            })
            
        }
    }
    
    private func startGroceryPollingIfNeeded() {
        guard viewModel.shouldPollGroceries else { return }
        
        // Don't restart if already polling
        guard pollingTimer == nil else { return }
        
        pollingTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
            Task {
                await viewModel.checkGroceryGenerationStatus()
            }
        }
    }
    
    private func stopGroceryPolling() {
        pollingTimer?.invalidate()
        pollingTimer = nil
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
}

private extension GroceriesView {
    func onReceiveItems(_ items: [GroceryItem]) -> some ViewModifier {
        return OnReceiveItemsModifier(items: items) { _ in
            viewModel.recalculateProgress()
        }
    }
}
