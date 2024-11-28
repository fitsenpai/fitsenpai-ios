//
//  WorkoutViewModel.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/28/24.
//

import Foundation

class WorkoutViewModel: ObservableObject {
    @Published var isSelected: Bool
    @Published var showInfo: Bool
    @Published var workout: Workout
    
    init(workout: Workout) {
        self.workout = workout
        self.isSelected = false
        self.showInfo = false
    }
    
    // Toggle selection state
    func toggleSelection() {
        isSelected.toggle()
    }
    
    // Toggle information visibility
    func toggleInfo() {
        showInfo.toggle()
    }
}
