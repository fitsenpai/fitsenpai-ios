//
//  MainContainerView.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/8/25.
//

import SwiftUI
import SuperwallKit

struct MainContainerView<Content: View>: View {
    @EnvironmentObject private var viewModel: MainViewModel
    @AppState(\.isLimited) private var isLimited: Bool
    
    let content: Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 12) {
                headerView

                if isLimited {
                    UpgrageCardView {
//                        viewModel.activeSheet = .subscription
                        Superwall.shared.register(placement: "campaign_trigger")
                    }
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
            
            SwipeableCalendarView(selectedDate: $viewModel.selectedDate, currentWeekStartDate: $viewModel.currentWeekStartDate, progressData: $viewModel.progressData, highlightedDays: $viewModel.highlightedDays)
                .blur(radius: isLimited ? 4 : 0)
        }
    }
}
