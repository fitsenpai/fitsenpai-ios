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
                    Label("Workouts", image: "ic_barbel")
                }
            
            MealsMainView()
                .tabItem {
                    Label("Meals", image: "ic_meals")
                }
            
            GroceriesMainView()
                .tabItem {
                    Label("Groceries", image: "ic_groceries")
                }
            ProfileMainView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
        }
        .tint(.fsPrimary)
    }
}

#Preview {
    FSTabView()
}
