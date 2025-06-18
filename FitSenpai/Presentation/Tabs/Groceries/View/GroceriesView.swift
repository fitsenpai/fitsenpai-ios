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
    
    var generatingViewModel: FSInfoViewModel {
        .init(
            iconName: nil,
            title: "Generating grocery list...",
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
                case .loading, .fetching, .updating:
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
}

private extension GroceriesView {
    func onReceiveItems(_ items: [GroceryItem]) -> some ViewModifier {
        return OnReceiveItemsModifier(items: items) { _ in
            viewModel.recalculateProgress()
        }
    }
}
