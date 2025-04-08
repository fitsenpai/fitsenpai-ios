//
//  FSTabView.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/22/24.
//

import SwiftUI

struct FSTabView: View {
    @StateObject private var viewModel: MainViewModel = .init()
    var body: some View {
        NavigationStack {
            TabView {
                Group {
                    WorkoutsMainView()
                        .tabItem {
                            Label("Workouts", image: "tab_workout")
                        }
                    
                    MealsMainView()
                        .tabItem {
                            Label("Meals", image: "tab_meals")
                        }
                    
                    GroceriesMainView()
                        .tabItem {
                            Label("Groceries", image: "tab_groceries")
                        }
                    
                    ProgressMainView()
                        .tabItem {
                            Label("Progress", image: "tab_progress")
                        }
                }
                .toolbarBackground(.white, for: .tabBar)
                .toolbarBackground(.visible, for: .tabBar)
                .environmentObject(viewModel)
            }
            .background(Color.white)
            .accentColor(.black)
        }
    }
}

#Preview {
    FSTabView()
}
