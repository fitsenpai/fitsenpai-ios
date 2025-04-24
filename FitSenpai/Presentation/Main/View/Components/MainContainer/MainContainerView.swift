//
//  MainContainerView.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/8/25.
//

import SwiftUI

struct MainContainerView<Content: View>: View {
    @EnvironmentObject private var viewModel: MainViewModel
    @EnvironmentObject private var superwall: SuperwallManager
    
    let content: Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 12) {
                headerView

                if superwall.isFirstDayTrialActive {
                    UpgrageCardView {
                        triggerHaptics()
                        superwall.presentPaywall(for: .proContent)
                    }
                    .padding(.horizontal, 24)
                }
                
            }
            ZStack {
                Color.clear
                content
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)

            }
        }
        .fullScreenCover(item: $viewModel.activeSheet, content: { sheet in
            SubscriptionView()
        })
    }
    
    var headerView: some View {
        VStack(alignment: .leading) {
            FSNavBarView()
            SwipeableCalendarView(currentWeekOffset: $viewModel.currentWeekOffset, selectedDate: $viewModel.selectedDate, currentWeekStartDate: $viewModel.currentWeekStartDate, progressData: $viewModel.progressData, highlightedDays: $viewModel.highlightedDays)
                .blur(radius: superwall.isFirstDayTrialActive ? 4 : 0)
                .disabled(superwall.isFirstDayTrialActive)
        }
    }
}
