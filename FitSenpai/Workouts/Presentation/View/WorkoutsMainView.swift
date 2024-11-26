//
//  WorkoutsMainView.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/22/24.
//

import SwiftUI

struct WorkoutsMainView: View {
    
    var listingHeader: some View {
        HStack(spacing: 12) {
            Image("ic_barbel_green")
                .resizable()
                .frame(width: 32, height: 32)
            FSText(text: "Today's workout", fontStyle: .headers20, color: .fsTitle)
            Spacer()
        }
    }
    
    var targetGroupHorizontalList: some View {
        HStack (spacing: 12) {
            GrayPillView(text: "Upper Body", pillHeight: 32, fontStyle: .body16)
            Spacer()
        }
    }
    
    var workoutSection: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray230, lineWidth: 1)
            VStack(spacing: 16) {
                VStack {
                    listingHeader
                    targetGroupHorizontalList
                }   
                FSCompletionBarView()
                
                
                List {
                    Section {
                        // Top padding for the first row
                        WorkoutView(image: "ic_workout", title: "General warm-up", isSelected: false, showInfo: false)
                            .frame(height: 88)
                            .listRowSeparator(.hidden)
                            .padding(.top, 12) // Add top padding here

                        WorkoutView(image: "ic_workout", title: "Bench press", isSelected: true, showInfo: true)
                            .frame(height: 88)
                            .listRowSeparator(.hidden)
                            .padding(.bottom, 12) // Add bottom padding here
                    }
                    // Removes the default left and right padding
                    .listRowInsets(EdgeInsets(top: 0, leading: 1, bottom: 0, trailing: 1))
                }
                .listStyle(PlainListStyle())
                .listRowSpacing(12) // Maintain spacing between rows
                
            }
            .padding(16)
                
        }
    }
    
    var workoutSection2: some View {
        VStack(spacing: 16) {
            VStack {
                listingHeader
                targetGroupHorizontalList
            }
            FSCompletionBarView()
            
            ScrollView {
                VStack(spacing: 12) {
                    WorkoutView(image: "ic_workout", title: "General warm-up", isSelected: false, showInfo: false)
                        .frame(height: 88)

                    WorkoutView(image: "ic_workout", title: "Bench press", isSelected: true, showInfo: true)
                        .frame(height: 88)
                }
                .padding(.horizontal, 1)
            }
        }
        .padding(.vertical, 16)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            FSText(text: "Workout planner", fontStyle: .headers24, color: .fsTitle)
            SwipeableCalendarView()
            
            workoutSection
            
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    WorkoutsMainView()
}
