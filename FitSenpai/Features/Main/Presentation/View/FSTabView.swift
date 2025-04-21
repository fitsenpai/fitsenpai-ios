//
//  FSTabView.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/22/24.
//

import SwiftUI

struct FSTabView: View {
    @StateObject private var viewModel: MainViewModel = .init()
    @EnvironmentObject private var appViewModel: AppViewModel
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationStack {
            TabView(selection: $selectedTab) {
                Group {
                    WorkoutsMainView()
                        .tabItem {
                            Label("Workouts", image: "tab_workout")
                        }
                        .tag(0)
                    
                    MealsMainView()
                        .tabItem {
                            Label("Meals", image: "tab_meals")
                        }
                        .tag(1)
                    
                    GroceriesMainView()
                        .tabItem {
                            Label("Groceries", image: "tab_groceries")
                        }
                        .tag(2)
                    
                    ProgressMainView()
                        .tabItem {
                            Label("Progress", image: "tab_progress")
                        }
                        .tag(3)
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
                SignInView()
            }
        }
    }
    
    private func triggerHaptics() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
}

#Preview {
    FSTabView()
        .environmentObject(AppViewModel())
}
