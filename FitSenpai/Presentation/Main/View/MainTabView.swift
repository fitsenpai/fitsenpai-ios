//
//  MainTabView.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/22/24.
//

import SwiftUI

struct MainTabView: View {
    @StateObject private var viewModel: MainViewModel = .init()
    @StateObject private var mealsViewModel: MealsViewModel = .init()
    @EnvironmentObject private var appViewModel: AppViewModel
    @State private var selectedTab: FSTabs = .workouts
    
    var body: some View {
        NavigationStack {
            TabView(selection: $selectedTab) {
                Group {
                    WorkoutsView()
                        .tabItem {
                            Label(FSTabs.workouts.title, image: FSTabs.workouts.icon)
                        }
                        .tag(FSTabs.workouts)
                    
                    MealsView(viewModel: mealsViewModel)
                        .tabItem {
                            Label(FSTabs.meals.title, image: FSTabs.meals.icon)
                        }
                        .tag(FSTabs.meals)
                    
                    GroceriesView(viewModel: mealsViewModel)
                        .tabItem {
                            Label(FSTabs.groceries.title, image: FSTabs.groceries.icon)
                        }
                        .tag(FSTabs.groceries)
                    
                    ProgressMainView()
                        .tabItem {
                            Label(FSTabs.progress.title, image: FSTabs.progress.icon)
                        }
                        .tag(FSTabs.progress)
                }
                .toolbarBackground(.white, for: .tabBar)
                .toolbarBackground(.visible, for: .tabBar)
                .environmentObject(viewModel)
            }
            .background(Color.white)
            .accentColor(.black)
            .onChange(of: selectedTab) { _, _ in
                triggerHaptics()
            }
            .fullScreenCover(isPresented: $appViewModel.shouldSignIn) {
                SigninAccountView()
            }
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(AppViewModel())
}
