//
//  FSTabView.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/22/24.
//

import SwiftUI

struct FSTabView: View {
    var body: some View {
        TabView {
            WorkoutsMainView.create()
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
            ProfileMainView()
                .tabItem {
                    Label("Progress", image: "tab_progress")
                }
        }
        .accentColor(.black)
    }
}

#Preview {
    FSTabView()
}
